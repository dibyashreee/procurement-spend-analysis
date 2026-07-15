# Procurement Spend Analysis: VA Federal Contract Data (FY2024)

I wanted a portfolio project that looked like real analyst work, not another Kaggle tutorial dashboard — so I pulled real federal contract data from USAspending.gov and worked through the mess procurement teams actually deal with: duplicate vendor records, unclear spend concentration, and no easy way to see where non-competed contracts might be worth a second look.

This is that project — 111,887 real Department of Veterans Affairs contract transactions from FY2024, cleaned, analyzed, and turned into something a procurement team could actually use.

**Built with:** SQL Server, Python (Pandas, rapidfuzz), Excel, Power BI

---

## What I Was Trying to Answer

1. Once you clean up the vendor records, who is the VA actually spending with?
2. How concentrated is that spend — a few big vendors, or spread thin?
3. Which non-competed contracts are worth flagging for a closer look?

## What I Found

| Question | Answer |
|---|---|
| How messy was the vendor data? | 12,010 raw vendor name spellings → **11,828 real, distinct vendors** |
| How concentrated is spend? | Top 10 vendors = **46.2%** of everything spent. Top 84 vendors (under 1%) drive **80%** of it |
| What about the long tail? | **4,356 vendors** (37%) show up for exactly one transaction, ever |
| Where's the risk? | **$12.8B** in spend went through non-competed contracts to smaller vendors — the segment most worth a procurement review |
| Any seasonal pattern? | Yes — a sharp spike in **September**, right at fiscal year-end. Classic "spend it before it disappears" budget behavior |

Full write-up with all the numbers: [`docs/Procurement_Spend_Analysis_Complete.docx`](docs/Procurement_Spend_Analysis_Complete.docx)

## Dashboard



## The Part I Actually Learned Something From

I started out assuming fuzzy string matching could mostly auto-clean vendor names. It can't — not safely, anyway.

Out of 225 name pairs the algorithm flagged as "probably duplicates," a good chunk weren't:

- **"Northwestern University" and "Northeastern University"** scored over 95% similar. They're obviously not the same school.
- I almost merged **"Advantage Prosthetics & Orthotics"** into a completely unrelated **"Advanced Prosthetics"** vendor cluster — the names just *sound* alike. Caught it on review, but it's a good reminder that a high similarity score doesn't mean anything on its own.

In the end, 54 of those 225 pairs really were the same vendor spelled differently. The other 171 needed to stay separate. That gap is basically the whole argument for why this kind of cleanup can't be fully automated.

## How It's Organized

├── sql/                  Setup → vendor cleanup → analysis views, numbered in order
├── python/               The cleaning, fuzzy-matching, and exploration notebook
├── excel/                A spend classification workbook, for people who live in Excel
├── powerbi/              The interactive dashboard
├── data/
│   ├── raw/              A small sample of the original data (full pull is 111K+ rows)
│   ├── processed/        Sample of the cleaned version
│   └── vendor_cleaning/  Every step of the vendor dedup process, kept as an audit trail
└── docs/                 Full write-up, charts, dashboard images

## How I Actually Built This

1. Pulled a filtered slice of USAspending.gov's contract data — VA only, FY2024, trimmed from 297 columns down to the 13 that mattered
2. Cleaned up vendor names in SQL first (easy stuff — punctuation, capitalization), then ran fuzzy matching in Python to catch the harder duplicates, then reviewed every single flagged pair by hand
3. Built five SQL views on top of the cleaned data — vendor concentration, category spend, competition status, monthly trends, and a risk-flagging view combining vendor size with competition status
4. Packaged the vendor-level results into an Excel workbook, since a lot of procurement folks still work in spreadsheets day-to-day
5. Pulled it all together into a Power BI dashboard

I cross-checked every major number — the $12.8B risk figure, the 46.2% concentration, the September spike — across SQL, Python, Excel, and Power BI along the way. They all agree, which was oddly satisfying given how many places this could have gone wrong.

## Where the Data Came From

[USAspending.gov](https://www.usaspending.gov/) — Custom Award Data Download, filtered to Department of Veterans Affairs contracts, FY2024 (Oct 2023–Sep 2024).

## About Me

Dibyashree Dey | [LinkedIn](https://linkedin.com/in/dibyashreedey)
