import sqlite3, tempfile, unittest
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from build_database import build_database

class DatabaseTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory(ignore_cleanup_errors=True); self.db=build_database(Path(self.tmp.name)/"test.db"); self.conn=sqlite3.connect(self.db)
    def tearDown(self): self.conn.close(); self.tmp.cleanup()
    def test_foreign_keys_and_counts(self):
        self.assertEqual(self.conn.execute("PRAGMA foreign_key_check").fetchall(),[])
        self.assertEqual(self.conn.execute("SELECT COUNT(*) FROM operations").fetchone()[0],17)
    def test_lead_kpis_are_calculable(self):
        total=self.conn.execute("SELECT SUM(actual_cost_brl) FROM operations").fetchone()[0]
        self.assertGreater(total,0)
        self.assertEqual(self.conn.execute("SELECT COUNT(*) FROM operations WHERE actual_cost_brl>planned_cost_brl").fetchone()[0],10)
    def test_high_risk_machine_exists(self):
        count=self.conn.execute("SELECT COUNT(*) FROM machines m WHERE engine_hours>=4000 AND (SELECT COUNT(*) FROM maintenance_events e WHERE e.machine_id=m.machine_id AND event_type='Corrective')>=2").fetchone()[0]
        self.assertGreaterEqual(count,1)

if __name__ == "__main__": unittest.main()
