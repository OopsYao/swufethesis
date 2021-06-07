# 生成所有的单元测试文件
import os
import re

files = os.listdir('testfiles')
pat = re.compile(r'\.lvt$')
tasks = (pat.sub('', f) for f in files if pat.search(f))
os.system(f'l3build save {" ".join(tasks)}')