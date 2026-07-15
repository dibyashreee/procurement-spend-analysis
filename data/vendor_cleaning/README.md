# Vendor Cleaning Data

Audit trail for vendor master data deduplication (12,010 raw vendor names → 11,828 canonical vendors).
Includes: fuzzy match candidates before review, the same candidates after manual review (MERGE/KEEP_SEPARATE decisions), and the final crosswalk mapping every raw name to its canonical vendor and vendor ID.
Full methodology documented in `/python/01_data_cleaning_and_eda.ipynb` and the project findings doc.
