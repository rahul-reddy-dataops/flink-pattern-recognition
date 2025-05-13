-- Create a Kafka table for storing detected transaction patterns --
CREATE TABLE suspicious_transaction_patterns (
  service_id STRING NOT NULL,
  txn_id_1 STRING NOT NULL,
  txn_id_2 STRING NOT NULL,
  txn_id_3 STRING NOT NULL,
  ts_1 TIMESTAMP_LTZ(3),
  ts_2 TIMESTAMP_LTZ(3),
  ts_3 TIMESTAMP_LTZ(3),
  amount_1 INT,
  amount_2 INT,
  amount_3 INT
)
WITH (
  'connector' = 'confluent',
  'changelog.mode' = 'append',
  'value.format' = 'json-registry',
  'scan.startup.mode' = 'earliest-offset',
  'scan.bounded.mode' = 'unbounded',
  'kafka.retention.time' = '7 d',
  'kafka.retention.size' = '0 bytes',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.cleanup-policy' = 'delete'
);

-- Pattern recognition query to detect sequences of high-value transactions --
-- Example pattern: three increasing amounts within 10 minutes
INSERT INTO suspicious_transaction_patterns
SELECT
  service_id,
  txn_id_1,
  txn_id_2,
  txn_id_3,
  ts_1,
  ts_2,
  ts_3,
  amount_1,
  amount_2,
  amount_3
FROM transaction_events
MATCH_RECOGNIZE (
  PARTITION BY service_id
  ORDER BY event_time
  MEASURES
    A.txn_id AS txn_id_1,
    B.txn_id AS txn_id_2,
    C.txn_id AS txn_id_3,
    A.event_time AS ts_1,
    B.event_time AS ts_2,
    C.event_time AS ts_3,
    A.amount AS amount_1,
    B.amount AS amount_2,
    C.amount AS amount_3
  ONE ROW PER MATCH
  AFTER MATCH SKIP TO NEXT ROW
  PATTERN (A B C)
  DEFINE
    A AS A.amount > 30000,
    B AS B.amount > 50000,
    C AS C.amount > 400000 AND C.event_time <= B.event_time + INTERVAL '10' MINUTE
);
