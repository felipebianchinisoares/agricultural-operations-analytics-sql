from pathlib import Path
import csv, sqlite3
from build_database import ROOT, DB, build_database

def split_queries(text):
    return [q.strip() for q in text.split(";") if q.strip() and not q.strip().startswith("--")]

def run():
    if not DB.exists(): build_database()
    out = ROOT / "results"; out.mkdir(exist_ok=True)
    text=(ROOT / "sql" / "analysis.sql").read_text(encoding="utf-8")
    # Preserve query comments as section separators.
    queries=[]; current=[]
    for line in text.splitlines():
        if line.strip().startswith("--") and current: queries.append("\n".join(current)); current=[]
        elif not line.strip().startswith("--"): current.append(line)
    if current: queries.append("\n".join(current))
    with sqlite3.connect(DB) as conn:
        for i,query in enumerate([q.strip().rstrip(';') for q in queries if q.strip()],1):
            cur=conn.execute(query); rows=cur.fetchall(); path=out/f"analysis_{i}.csv"
            with path.open("w",newline="",encoding="utf-8") as f: w=csv.writer(f); w.writerow([d[0] for d in cur.description]); w.writerows(rows)
            print(path)

if __name__ == "__main__": run()
