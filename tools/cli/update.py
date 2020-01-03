import subprocess

process = subprocess.call(['docker-compose', 'down'])

process = subprocess.call(['git', 'pull'])

process = subprocess.call(
    ['docker-compose', 'up', '-d', '--build', '--force-recreate'])
