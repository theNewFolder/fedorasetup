# AI Tools Integration - Claude + Gemini Workflow
# Multi-model AI CLI and integration tools

{ config, pkgs, ... }:

{
  # AI CLI Tools
  home.packages = with pkgs; [
    # Python with AI SDKs
    (python3.withPackages (ps: with ps; [
      google-generativeai  # Gemini SDK (google.generativeai)
      requests
      rich
      prompt-toolkit
    ]))

    # JSON processor for API calls
    jq
  ];

  # Environment variables for AI APIs
  home.sessionVariables = {
    # Gemini API Key
    GEMINI_API_KEY = "AIzaSyD8xW0X7Rfyn3nDwRyw0pPwMe2W62SLm-w";

    # Claude API Key (if available)
    ANTHROPIC_API_KEY = "$(cat ${config.home.homeDirectory}/.secrets/claude-api-key.txt 2>/dev/null || echo '')";
  };

  # Simple Gemini CLI wrapper
  home.file.".local/bin/gemini-cli".text = ''
    #!/usr/bin/env python3
    import os
    import sys
    import json
    import google.generativeai as genai

    # Configure API
    genai.configure(api_key=os.getenv('GEMINI_API_KEY'))

    # Create model
    model = genai.GenerativeModel('gemini-2.0-flash-exp')

    # Get prompt from args or stdin
    if len(sys.argv) > 1:
        prompt = ' '.join(sys.argv[1:])
    else:
        prompt = sys.stdin.read()

    # Generate response
    try:
        response = model.generate_content(prompt)
        print(response.text)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
  '';

  home.file.".local/bin/gemini-cli".executable = true;

  # Shell aliases for AI workflow
  programs.zsh.shellAliases = {
    # AI Chat Commands
    "gemini" = "gemini-cli";
    "ai" = "gemini-cli";

    # Piped workflows
    "ai-commit" = "git diff --staged | gemini-cli 'Generate a concise git commit message for these changes:'";
    "ai-explain" = "gemini-cli 'Explain this command:'";
    "ai-fix" = "gemini-cli 'Find and fix issues in this code:'";
  };

  # Simple AI helper scripts
  home.file.".local/bin/ai-ask".text = ''
    #!/usr/bin/env bash
    # Simple Gemini query
    echo "🤖 Gemini AI Assistant"
    gemini-cli "$@"
  '';

  home.file.".local/bin/ai-ask".executable = true;
}
