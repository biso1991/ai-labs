# Notebook Fix Log

## Issue: Invalid Notebook Structure

**Date**: November 15, 2026  
**Notebook**: `In-Context Learning and Prompt Templates for Advanced AI.ipynb`

---

## Error Message

```
Invalid Notebook
{'cell_type': 'markdown', 'metadata': {}, 'outputs': [], 'source': '...'} 
is not valid under any of the given schemas
Using nbformat v5.10.4 and nbconvert v7.17.2
```

---

## Root Cause

The notebook had **86 markdown cells** with an `'outputs': []` field. In Jupyter Notebook format (nbformat v4), only **code cells** should have the `outputs` field. Markdown cells should not have this field.

This commonly happens when:
- Converting from other formats
- Manually editing notebook JSON
- Using incompatible notebook tools

---

## Fix Applied

### Automated Fix Script

```python
import json

# Read notebook
with open(notebook_path, 'r', encoding='utf-8') as f:
    notebook = json.load(f)

# Fix each cell
for cell in notebook['cells']:
    cell_type = cell.get('cell_type')
    
    # Markdown cells: remove outputs and execution_count
    if cell_type == 'markdown':
        if 'outputs' in cell:
            del cell['outputs']
        if 'execution_count' in cell:
            del cell['execution_count']
    
    # Code cells: ensure outputs and execution_count exist
    elif cell_type == 'code':
        if 'outputs' not in cell:
            cell['outputs'] = []
        if 'execution_count' not in cell:
            cell['execution_count'] = None

# Save fixed notebook
with open(notebook_path, 'w', encoding='utf-8') as f:
    json.dump(notebook, f, indent=2, ensure_ascii=False)
```

---

## Validation Results

### Before Fix
- ❌ 86 markdown cells with invalid `outputs` field
- ❌ Failed nbformat validation
- ❌ Could not open in Jupyter

### After Fix
- ✅ All markdown cells corrected
- ✅ Passed nbformat validation
- ✅ Opens successfully in Jupyter/JupyterLab
- ✅ Compatible with GitHub Codespaces

---

## Notebook Statistics

- **Format**: Jupyter Notebook v4.4
- **Total Cells**: 114
  - Markdown: 86
  - Code: 28
- **Issues Fixed**: 86
- **Validation**: Passed ✅

---

## Prevention Tips

To avoid this issue in the future:

1. **Use official Jupyter tools** for creating/editing notebooks
2. **Validate notebooks** before committing:
   ```bash
   python3 -c "import nbformat; nbformat.validate(nbformat.read('notebook.ipynb', as_version=4))"
   ```
3. **Add pre-commit hook** to validate notebooks automatically
4. **Convert carefully** when moving between formats

---

## Quick Validation Script

Save this as `validate_notebook.py`:

```python
#!/usr/bin/env python3
import sys
import nbformat
from nbformat.validator import validate

if len(sys.argv) < 2:
    print("Usage: python validate_notebook.py <notebook.ipynb>")
    sys.exit(1)

notebook_path = sys.argv[1]

try:
    with open(notebook_path, 'r', encoding='utf-8') as f:
        nb = nbformat.read(f, as_version=4)
    validate(nb)
    print(f"✅ {notebook_path} is valid!")
except Exception as e:
    print(f"❌ {notebook_path} validation failed: {e}")
    sys.exit(1)
```

Usage:
```bash
python validate_notebook.py "labs/your-notebook.ipynb"
```

---

## References

- [Jupyter Notebook Format](https://nbformat.readthedocs.io/)
- [nbformat Documentation](https://nbformat.readthedocs.io/en/latest/format_description.html)
- [Cell Types Specification](https://nbformat.readthedocs.io/en/latest/format_description.html#cell-types)

---

**Status**: ✅ Resolved and documented
