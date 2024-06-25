import 'dart:developer';
import 'dart:io';

void main() {
  final rootDir = Directory.current;
  final commitFile = File('${rootDir.path}/.git/COMMIT_EDITMSG');

  if (!commitFile.existsSync()) {
    log('🚨 No commit message file found 🚨');
    exit(1);
  }

  final commitMessage = commitFile.readAsStringSync().trim();
  final commitPattern = RegExp(
    r'^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert|merge)(\([a-zA-Z0-9._-]+\))?(\:|!\:)\s[^\n\rA-Z]+$',
  );

  final isValid = commitPattern.hasMatch(commitMessage);

  if (isValid) {
    log('👍 Nice commit message dude!');
  } else {
    log(
      '''
          👎 Your commit message does not follow the Conventional Commits format.
          A valid commit message should look like one of the following examples:
          - fix: correct minor typos in code
          - feat(login): add the remember me feature
          - docs(readme): update install instructions

          For more information on the Conventional Commits specification, visit:
          https://www.conventionalcommits.org/pt-br/v1.0.0/
          ''',
    );
    exit(1);
  }
}
