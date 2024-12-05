from collections import defaultdict

rules, updates  = open("input.txt").read().strip().split("\n\n")

tbl = defaultdict(set)
[tbl[int(k)].add(int(v)) for k, v in (line.split("|") for line in rules.split("\n"))]

updates = [[int(n) for n in line.split(",")] for line in updates.split("\n")]

def verify_update(update):
    return all(update[j] in tbl[update[i]] for i in range(len(update)) for j in range(i + 1, len(update)))

def fix_pages(pages):
    for i in range(len(pages)):
        for j in range(i + 1, len(pages)):
            if pages[j] not in tbl[pages[i]]:
                pages.insert(i, pages.pop(j))
    return pages

b = sum([pages[len(pages) // 2] for update in updates if not verify_update(update) for pages in [fix_pages(update)]])

print(f"b: {b}")
