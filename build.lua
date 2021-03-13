module = "swufethesis"

sourcefiles = {"*.dtx", "*-doc.tex", "*.ins", "assets/swufethesis-bachelor-backcover.pdf", "assets/swufethesis-bachelor-logo.png"}
-- 这里的文件名（glob）应该是对于unpackdir（默认为build/unpacked目录）来讲的
-- l3build的文档里似乎没有找到相关的说明，从源码里能找到依据
-- https://github.com/latex3/l3build/blob/f0174fee3b19b1faceb3a59b938cef9c144d6a7e/l3build-unpack.lua#L67
-- 似乎unpackdir只有installfiles匹配的文件才会被移入localdir，而localdir算是类似于local-texmf一类的目录
-- 从而installfiles的设置不仅仅是在打包ctan时才会用到，还包括doc等
installfiles = {"*.cls", "swufethesis-bachelor-logo.png", "swufethesis-bachelor-backcover.pdf"}

checkengines = {"xetex"}
stdengine = "xetex"

-- 生成doc所用程序
typesetexe = "xelatex"
typesetsuppfiles = {"swufedoc.cls"}

packtdszip = true

