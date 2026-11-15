#!/bin/bash
# Quick script to add a new lab to the ai-labs repository

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        AI Labs - Quick Add New Lab Script                ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo

# Check if file path is provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: $0 /path/to/your/notebook.ipynb [\"Lab Description\"]${NC}"
    echo
    echo "Example:"
    echo "  $0 /home/bilel/Documents/my-lab.ipynb \"Deep Learning Fundamentals\""
    exit 1
fi

LAB_FILE="$1"
LAB_DESC="${2:-New Lab}"

# Check if file exists
if [ ! -f "$LAB_FILE" ]; then
    echo -e "${YELLOW}Error: File not found: $LAB_FILE${NC}"
    exit 1
fi

# Get the filename
FILENAME=$(basename "$LAB_FILE")

# Navigate to repo
REPO_DIR="$HOME/Desktop/ai-labs"
if [ ! -d "$REPO_DIR" ]; then
    echo -e "${YELLOW}Error: ai-labs repository not found at $REPO_DIR${NC}"
    exit 1
fi

cd "$REPO_DIR"

echo -e "${BLUE}📁 Repository:${NC} $REPO_DIR"
echo -e "${BLUE}📄 Lab File:${NC} $FILENAME"
echo -e "${BLUE}📝 Description:${NC} $LAB_DESC"
echo

# Copy the file
echo -e "${GREEN}Copying notebook to labs/ directory...${NC}"
cp "$LAB_FILE" labs/

# Check if copy was successful
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Error: Failed to copy file${NC}"
    exit 1
fi

echo -e "${GREEN}✓ File copied successfully${NC}"
echo

# Git operations
echo -e "${GREEN}Adding to git...${NC}"
git add "labs/$FILENAME"

echo -e "${GREEN}Creating commit...${NC}"
git commit -m "Add: $LAB_DESC

- Added $FILENAME to labs directory"

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Warning: Commit failed (maybe no changes?)${NC}"
fi

echo -e "${GREEN}Pushing to GitHub...${NC}"
git push origin main

if [ $? -eq 0 ]; then
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               ✅ Lab Added Successfully!                  ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}🔗 Repository:${NC} https://github.com/biso1991/ai-labs"
    echo -e "${BLUE}📓 Lab Location:${NC} labs/$FILENAME"
    echo
    echo -e "${YELLOW}💡 Don't forget to update README.md with lab description!${NC}"
else
    echo -e "${YELLOW}Error: Failed to push to GitHub${NC}"
    exit 1
fi
