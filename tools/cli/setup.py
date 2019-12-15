from setuptools import setup

setup(
    name='hub',
    version='0.1',
    py_modules=['main'],
    install_requires=[
        'click',
    ],
    entry_points='''
        [console_scripts]
        hub=main:application
    ''',
)
