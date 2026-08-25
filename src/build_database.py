from pathlib import Path
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "data" / "agricultural_operations.db"

def build_database(db_path=DB):
    db_path = Path(db_path)
    db_path.parent.mkdir(parents=True, exist_ok=True)
    if db_path.exists(): db_path.unlink()
    with sqlite3.connect(db_path) as conn:
        conn.executescript((ROOT / "sql" / "schema.sql").read_text(encoding="utf-8"))
        conn.executescript((ROOT / "data" / "seed.sql").read_text(encoding="utf-8"))
    return db_path

if __name__ == "__main__": print(build_database())
