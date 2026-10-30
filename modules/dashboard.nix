{ config, pkgs, ... }:

{
  # ---------------------------------------------------------
  # NATIVE DECLARATIVE DASHBOARD & DOCUMENTATION RENDERER
  # ---------------------------------------------------------
  
  environment.etc."dashboard/index.html".text = ''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Home Server Dashboard</title>
      <style>
        body { font-family: system-ui, -apple-system, sans-serif; background: #121212; color: #fff; margin: 0; padding: 40px; }
        .container { max-width: 900px; margin: 0 auto; }
        h1 { font-weight: 300; margin-bottom: 5px; }
        p.subtitle { color: #888; margin-bottom: 40px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
        .card { background: #1e1e1e; border-radius: 12px; padding: 20px; text-decoration: none; color: #fff; display: flex; align-items: center; transition: background 0.2s, transform 0.2s; border: 1px solid #333; }
        .card:hover { background: #2a2a2a; transform: translateY(-3px); border-color: #555; }
        .icon { font-size: 2.5rem; margin-right: 20px; width: 50px; text-align: center; }
        .manual { color: #10b981; }
        .info h2 { margin: 0 0 5px 0; font-size: 1.2rem; }
        .info p { margin: 0; color: #aaa; font-size: 0.9rem; }
        .section-title { grid-column: 1 / -1; margin-top: 20px; margin-bottom: 10px; font-weight: 400; color: #ccc; border-bottom: 1px solid #333; padding-bottom: 10px; }
      </style>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
      <div class="container">
        <h1>Household Server</h1>
        <p class="subtitle">Services & Automation Stack</p>
        
        <div class="grid">
          <h3 class="section-title">System Status & Tools</h3>
          
          <a href="/manual/" target="_blank" class="card">
            <i class="fas fa-book-open icon manual"></i>
            <div class="info">
              <h2>Server Manual</h2>
              <p>Deployment & Operations</p>
            </div>
          </a>

          <!-- Example Service Card -->
          <a href="/files/" target="_blank" class="card">
            <i class="fas fa-folder-open icon" style="color: #fbbf24;"></i>
            <div class="info">
              <h2>Filebrowser</h2>
              <p>Web File Manager</p>
            </div>
          </a>
          
          <!-- TODO: Add future service cards here -->
          
        </div>
      </div>
    </body>
    </html>
  '';
  
  environment.etc."dashboard/manual/index.html".text = ''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Manual & Operations Wiki</title>
      <script src="https://cdn.tailwindcss.com"></script>
      <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/styles/github-dark.min.css">
      <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/highlight.min.js"></script>
      <style>
        body { background-color: #0f0f11; color: #e4e4e7; }
        .markdown-body h1 { font-size: 2.25rem; font-weight: 700; border-bottom: 1px solid #27272a; padding-bottom: 0.5rem; margin-top: 2rem; margin-bottom: 1rem; color: #fff; }
        .markdown-body h2 { font-size: 1.5rem; font-weight: 600; border-bottom: 1px solid #27272a; padding-bottom: 0.25rem; margin-top: 1.75rem; margin-bottom: 1rem; color: #f4f4f5; }
        .markdown-body h3 { font-size: 1.25rem; font-weight: 500; margin-top: 1.5rem; margin-bottom: 0.75rem; color: #e4e4e7; }
        .markdown-body p { margin-top: 0; margin-bottom: 1rem; line-height: 1.7; color: #a1a1aa; }
        .markdown-body ul, .markdown-body ol { padding-left: 2rem; margin-bottom: 1rem; list-style-type: decimal; }
        .markdown-body ul { list-style-type: disc; }
        .markdown-body li { margin-bottom: 0.25rem; line-height: 1.6; color: #d4d4d8; }
        .markdown-body code { background-color: #18181b; padding: 0.2rem 0.4rem; border-radius: 4px; font-family: monospace; font-size: 0.875em; color: #f43f5e; }
        .markdown-body pre code { background-color: transparent; padding: 0; font-size: 100%; color: inherit; }
        .markdown-body pre { background-color: #18181b; padding: 1rem; border-radius: 8px; border: 1px solid #27272a; overflow-x: auto; margin-bottom: 1.25rem; }
        .markdown-body table { width: 100%; border-collapse: collapse; margin-bottom: 1.5rem; }
        .markdown-body th, .markdown-body td { border: 1px solid #27272a; padding: 0.75rem; text-align: left; }
        .markdown-body th { background-color: #18181b; font-weight: 600; color: #fff; }
        .markdown-body blockquote { border-left: 4px solid #10b981; padding-left: 1rem; color: #34d399; background-color: #064e3b33; padding-top: 0.75rem; padding-bottom: 0.75rem; border-radius: 0 8px 8px 0; margin-bottom: 1.25rem; }
      </style>
    </head>
    <body class="py-12 px-4 md:px-8">
      <div class="max-w-4xl mx-auto bg-[#18181b] border border-[#27272a] rounded-2xl shadow-2xl p-6 md:p-12">
        <div class="flex items-center justify-between border-b border-zinc-800 pb-6 mb-8">
          <a href="/" class="text-emerald-400 hover:text-emerald-300 flex items-center gap-2 font-medium transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" /></svg>
            Back to Dashboard
          </a>
          <span class="text-xs text-zinc-500 uppercase tracking-widest font-mono">Operations manual</span>
        </div>
        
        <article id="content" class="markdown-body">
          <div class="flex items-center justify-center py-20">
            <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-emerald-500"></div>
          </div>
        </article>
      </div>

      <script>
        marked.setOptions({
          highlight: function(code, lang) {
            const language = hljs.getLanguage(lang) ? lang : 'plaintext';
            return hljs.highlight(code, { language }).value;
          },
          langPrefix: 'hljs language-'
        });

        fetch('./README.md')
          .then(response => {
            if (!response.ok) throw new Error('Failed to load manual markdown file.');
            return response.text();
          })
          .then(text => {
            document.getElementById('content').innerHTML = marked.parse(text);
          })
          .catch(err => {
            document.getElementById('content').innerHTML = `
              <div class="bg-red-950/20 border border-red-900 text-red-400 p-6 rounded-xl">
                <h3 class="font-bold text-lg mb-2">Error Loading Documentation</h3>
                <p>` + err.message + `</p>
              </div>
            `;
          });
      </script>
    </body>
    </html>
  '';
};