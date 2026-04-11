import pypdf

reader = pypdf.PdfReader("Yogya_Design_Proposal.pdf")
text = ""
for page in reader.pages:
    text += page.extract_text() + "\n"

with open("Yogya_Design_Proposal.txt", "w", encoding="utf-8") as f:
    f.write(text)
print("PDF text extracted to Yogya_Design_Proposal.txt")
