# 🔥 HaxShadow Fuzzer  
### *Precision Over Noise — Smart DAST for Real Bugs*

> **"Not all URLs are worth scanning. We scan only the ones that matter."**  
> — by **@TEAM_DH049**
---

## 🎯 Why HaxShadow?

Most recon tools flood you with **junk URLs** like:

These **break Nuclei’s DAST engine** because:
- They contain **fake/multiple `FUZZ` placeholders**
- Lack **real parameter values**
- Cause **false negatives** or **scan failures**

**HaxShadow fixes this** by:
✅ Extracting **only real-world URLs** (from `gau`)  
✅ Keeping **only valid query structures** (e.g., `?id=123`, not `?id=FUZZ`)  
✅ Skipping **active crawling** (saves hours!)  
✅ Feeding **clean, live, parameterized URLs** to Nuclei  

→ Result? **Faster scans, fewer false negatives, more real bugs.**

---

## 🛠️ What It Does

1. **Fetches passive URLs** using `gau` (from AlienVault, CommonCrawl, Wayback, etc.)
2. **Filters only URLs with real query parameters** (e.g., `?user=alice`, not `?user=`)
3. **Validates live endpoints** with `httpx` (status 200/301/302/403 only)
4. **Runs Nuclei in DAST mode** — the **only correct way** to test dynamic params
5. **Saves clean output** for manual verification

> ⚡ No ParamSpider. No Katana. No noise. Just **precision**.

---

## 📦 Requirements

Install these **once**:

```bash
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/tomnomnom/uro@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest


Usage :--

https://github.com/TEAM-DH49/scanner.git
cd scanner
chmod +x HaxShadow.sh
./HaxShadow.sh



