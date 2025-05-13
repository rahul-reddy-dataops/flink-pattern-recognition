# Flink SQL Pattern Recognition Project

This project demonstrates the use of **Flink SQL's MATCH_RECOGNIZE** clause to detect patterns of suspicious financial transactions over a Kafka stream.

## 💡 Objective

Identify sequences of three high-value transactions made by the same service within a short time window (e.g., 10 minutes), which may indicate fraudulent behavior.

## 🧱 Project Components

### 1. Kafka Source Table
Defines a streaming input from Kafka using Flink SQL with JSON format and a schema representing transaction events.

### 2. Pattern Recognition
Uses `MATCH_RECOGNIZE` to detect the following pattern:
- Transaction A: amount > 30,000
- Transaction B: amount > 50,000
- Transaction C: amount > 400,000
- All events must occur within 10 minutes

### 3. Output Table
Stores the suspicious transaction patterns in a separate Kafka topic or sink table.

## 📥 Sample Output

See the `sample_output.csv` file for an example of the expected output.

## 🛠 Technologies Used

- Apache Flink
- Flink SQL (Pattern Recognition / MATCH_RECOGNIZE)
- Kafka
- JSON Schema Registry

## 📂 Files

- `pattern_recognition_flink.sql`: Core SQL logic
- `README.md`: Project documentation
- `sample_output.csv`: Example result of the pattern recognition logic

## 🚀 Usage

This project can be integrated into any Flink + Kafka-based streaming pipeline. Simply plug in your Kafka topic and run the SQL via Flink SQL Gateway or any compatible interface.

---

Feel free to fork and adapt this logic to fit your own event detection use cases!
