from flask import Flask, request, jsonify
import sys, os
sys.path.insert(0, os.path.dirname(__file__))

# Copy your pdf_parser.py here or import it
from pdf_parser import extract_marksheet_fields, extract_marksheet_fields_from_image

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify({'status': 'ok'})

@app.route('/parse-pdf', methods=['POST'])
def parse_pdf():
    file = request.files.get('file')
    if not file:
        return jsonify({'error': 'No file uploaded'}), 400
    method = request.args.get('method', 'auto')
    result = extract_marksheet_fields(file.read(), method=method)
    return jsonify(result)

@app.route('/parse-image', methods=['POST'])
def parse_image():
    file = request.files.get('file')
    if not file:
        return jsonify({'error': 'No file uploaded'}), 400
    result = extract_marksheet_fields_from_image(file.read())
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5050, debug=False)