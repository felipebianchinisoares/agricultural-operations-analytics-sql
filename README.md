# Agricultural Operations Analytics with SQL

A reproducible portfolio project demonstrating SQL and Python skills through a synthetic agricultural-operations database. No employer, customer, John Deere, or proprietary platform data are used.

## Questions answered

- Which fields have the highest operating cost per hectare?
- Which machines accumulate the most downtime and maintenance events?
- How does yield vary by crop, field, and season?
- Which operations exceeded their planned cost?
- Which machines show a high-risk maintenance pattern?

## Skills demonstrated

- Relational modeling with primary and foreign keys
- `JOIN`, `GROUP BY`, subqueries, CTEs, and window functions
- Conditional aggregation and KPI calculation
- Data-quality checks
- SQLite integration with Python
- Automated tests and reproducible outputs

## Project structure

```text
data/seed.sql             Synthetic demonstration data
sql/schema.sql            Relational schema and constraints
sql/analysis.sql          Analytical queries
src/build_database.py     Creates and populates SQLite database
src/run_analysis.py       Executes analyses and exports CSV results
tests/test_database.py    Integrity and KPI tests
results/                  Generated outputs (not committed)
```

## Run

```bash
python src/build_database.py
python src/run_analysis.py
python -m unittest discover -s tests
```

The database is written to `data/agricultural_operations.db` and the query outputs to `results/`.

## Data ethics

All records are fictional and were created solely for education and portfolio demonstration. Monetary values, yields, machine identifiers, farms, and maintenance events do not describe real companies or customers.

## Next steps

- Add PostgreSQL-compatible scripts.
- Build a Power BI dashboard from the exported CSV files.
- Add a machine-learning model for maintenance-risk classification.
- Add larger synthetic datasets and query-performance benchmarks.
