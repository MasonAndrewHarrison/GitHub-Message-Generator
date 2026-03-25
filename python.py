import subprocess
import requests


def get_diff():
    result = subprocess.run(
        [
            'git', 'diff', '--staged',
            '-U5',               
            '--function-context',   
            '-w',               
            '--ignore-blank-lines'
        ],
        capture_output=True,
        text=True
    )
    return result.stdout
    

def classify_diff(diff):
    added = []
    removed = []

    for line in diff.splitlines():
        if line.startswith('+') and not line.startswith('+++'):
            added.append(line[1:].strip())
        elif line.startswith('-') and not line.startswith('---'):
            removed.append(line[1:].strip())

    added = [l for l in added if l]
    removed = [l for l in removed if l]

    total_changes = len(added) + len(removed)

    if total_changes <= 2:
        return "trivial"

    if sorted(added) == sorted(removed):
        if total_changes > 10:
            return "reorder"
        else:
            return "trivial"

    return "functional"

def clean_message(msg):
    msg = msg.strip().lower()

    if not msg:
        return "update code logic"

    if len(msg.split()) > 10:
        return "update code logic"

    if any(word in msg for word in ["format", "whitespace", "blank"]):
        return "minor code tweak"

    return msg

def generate_commit_message(diff):
    try:
        response = requests.post(
            'http://localhost:11434/api/generate',
            json={
                "model": "qwen2.5-coder:7b",
                "prompt": f"""Write a git commit message (4-8 words).

            ONLY describe meaningful behavioral changes.

            Make your responces short about 4 to 8 words but NO LONGER THAN 10 WORDS, please.

            Use the surrounding function context to understand intent.

            IGNORE:
            - formatting
            - whitespace
            - reordering

            If the change is small AND unclear, respond EXACTLY:
            minor code tweak

            Diff with context:
            {diff}
            """,
                "stream": False
            },
            timeout=10
        )

        data = response.json()

        if 'response' not in data:
            print("API error:", data)
            return "update code logic"

        return data['response'].strip()

    except Exception as e:
        print("Request failed:", e)
        return "update code logic"


if __name__ == "__main__":
    diff = get_diff()

    if not diff.strip():
        print("No staged changes — run 'git add' first")
        exit(0)

    change_type = classify_diff(diff)

    if change_type == "trivial":
        message = "minor code tweak"

    elif change_type == "reorder":
        message = "refactor code structure"

    else:
        message = generate_commit_message(diff)
        message = clean_message(message)

    print(f"Committing: {message}")

    subprocess.run(['git', 'commit', '-m', message])