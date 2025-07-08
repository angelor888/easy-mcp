#!/usr/bin/env python3
import subprocess
import sys
import os

def create_pdf_with_markdown():
    """Convert markdown to PDF using Python markdown libraries"""
    try:
        import markdown
        import pdfkit
        
        with open('mcp-docker-compose-fixes-sop.md', 'r') as f:
            md_content = f.read()
        
        html_content = markdown.markdown(md_content, extensions=['tables', 'fenced_code'])
        
        # Add CSS for better formatting
        html_with_style = f"""
        <html>
        <head>
            <style>
                body {{ font-family: Arial, sans-serif; margin: 40px; }}
                h1 {{ color: #333; }}
                h2 {{ color: #555; }}
                h3 {{ color: #777; }}
                code {{ background-color: #f4f4f4; padding: 2px 4px; }}
                pre {{ background-color: #f4f4f4; padding: 10px; overflow-x: auto; }}
                table {{ border-collapse: collapse; width: 100%; margin: 20px 0; }}
                th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
                th {{ background-color: #f2f2f2; }}
            </style>
        </head>
        <body>
            {html_content}
        </body>
        </html>
        """
        
        pdfkit.from_string(html_with_style, 'mcp-docker-compose-fixes-sop.pdf')
        print("PDF created successfully!")
        
    except ImportError:
        print("Required libraries not installed. Trying alternative method...")
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False
    
    return True

def create_pdf_with_weasyprint():
    """Alternative method using weasyprint"""
    try:
        from weasyprint import HTML
        import markdown
        
        with open('mcp-docker-compose-fixes-sop.md', 'r') as f:
            md_content = f.read()
        
        html_content = markdown.markdown(md_content, extensions=['tables', 'fenced_code'])
        
        html_with_style = f"""
        <html>
        <head>
            <style>
                @page {{ margin: 2cm; }}
                body {{ font-family: Arial, sans-serif; line-height: 1.6; }}
                h1 {{ color: #333; page-break-after: avoid; }}
                h2 {{ color: #555; page-break-after: avoid; }}
                h3 {{ color: #777; page-break-after: avoid; }}
                code {{ background-color: #f4f4f4; padding: 2px 4px; font-family: monospace; }}
                pre {{ background-color: #f4f4f4; padding: 10px; overflow-x: auto; page-break-inside: avoid; }}
                table {{ border-collapse: collapse; width: 100%; margin: 20px 0; page-break-inside: avoid; }}
                th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
                th {{ background-color: #f2f2f2; font-weight: bold; }}
            </style>
        </head>
        <body>
            {html_content}
        </body>
        </html>
        """
        
        HTML(string=html_with_style).write_pdf('mcp-docker-compose-fixes-sop.pdf')
        print("PDF created successfully with weasyprint!")
        return True
        
    except ImportError:
        print("Weasyprint not installed.")
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False

def create_simple_text_pdf():
    """Fallback: Create a simple formatted text file that can be printed to PDF"""
    try:
        with open('mcp-docker-compose-fixes-sop.md', 'r') as f:
            content = f.read()
        
        # Create a nicely formatted text version
        with open('mcp-docker-compose-fixes-sop.txt', 'w') as f:
            f.write(content)
        
        print("Created text file: mcp-docker-compose-fixes-sop.txt")
        print("You can print this to PDF using: File > Print > Save as PDF")
        return True
        
    except Exception as e:
        print(f"Error creating text file: {e}")
        return False

# Try different methods
if not create_pdf_with_markdown():
    if not create_pdf_with_weasyprint():
        create_simple_text_pdf()