物理学还是计算机
================
Considering your family, getting rid of them completely, do you have any
other choice?

- 结论
  物理学成为一个爱好, 为量子计算做准备.
  在此之前, 专心攻克更多的计算机科学知识尤其是算法知识, 积累更多设计能力, 挣更多的钱.

周末在屋里看书还是去公司看书?
=============================
- 在屋里看书

  :pros: 安静, 不受闲杂人等打扰, 自在, 便于深入思考.
  :cons: 现在不是一个人, 会受到卫希的干扰. 自我约束会下降, 不能保持完全的理性,
         作出错误的行为和判断, 低效, 浪费时间. 例如, 吃饭时会看无意义的视频或
         动漫, 而且会延长至吃饭之后的很长时间.

- 在办公室看书

  :pros: 行动相对独立, 不会收到卫希的干扰. 在无闲杂人等的打扰前提下, 时间利用率
         较高. 结果和心情都比较好.
  :cons: 闲杂人等出现的概率较高. 在正常情况下, 组内部分人员和部分其他高层的出现,
         将导致办公室嘈杂不堪, 甚至出现邀请我去浪费时间的举动. 在这种情况下难以
         作为高效学习的场所.

- 结论: 在换公司之前, 在屋里看书, 逐渐做到不受卫希存在的影响. 尽快学习, 换公司.

Git large file versioning solution
==================================
- git annex + bup

  :pros:
         - 由于在 git database 中只保存 symlink, checkout/status/commit 等等
           速度都很快.

  :cons:
         - 会修改 pre-commit hook, 这样需要手动和我自己的 pre-commit hook 来合并,
           但这个修改对每个 repo 是一次性的, 所以还可以接受.

         - git annex 和 bup 并不能很好的协作. 整个流程并不自然, 比较繁琐.
           git annex 虽支持 bup 作为 remote, 却需要 bup 的 local 和 remote
           两端, 不能只要一个 local 的 bup 存储或一个 remote bup 存储.
           这样必有一个是没用的.

         - git annex 的存储 `.git/annex` 只能是一个个完整的文件. 并没有任何存储的
           节省. 不能用 bup 的存储作为本地的 `.git/annex`.

         - git annex 的操作步骤比 git lfs 繁琐.

         - git annex 会把每个推到 bup 的文件在 bup 中创建一个分支. 太傻逼了.
           而且设置了 `remote.<name>.annex-bup-split-options` 为 `-n <branch>`
           也没用, 因为它会再加一个 `-n`.

- git lfs

  :cons:
         - checkout/status/commit 等等都太卡了.

         - 和 git annex 一样, 不会减少空间占用.

- 结论:
  * git annex 单独使用可用来进行大文件版本管理, 它足够迅速. 但缺点是占用空间大.
    若不介意硬盘空间占用则可用.

  * bup 单独使用可以用来做大文件版本管理, 它对存储的使用比较高效. 若对硬盘空间
    比较介意则可用.

  * 目前, 将 git annex 和 bup 结合使用还有很多缺陷, 但基本可用.
    使用方式如下:

    - 每个 client 包含一个 local git repo (含 git annex).
      remote 包含一个 bare git repo 和 bup repo.

    - client 中, 设置 git remote 为 上述 remote bare git repo 和 remote bup repo.

    - 本地使用时, 只在 `.git/annex` 中保留最新版本的 annexed files (保证读取效率).

    - 从 local 向 remote 同步时, local git repo 如常 push 至 remote git repo,
      再将 annexed files 的各版本 copy 至 remote bup repo.
      (``git annex copy --to=<remote-bup> --not --in=<remote-bup>``)

    - 从 remote 向 local 同步时, local git repo 如常从 remote git repo 中 fetch,
      再将本地缺少的文件从 remote bup 中 get 至本地.

    此外, 也可以在 client 上加上一个 local bup repo, 这样的好处是 client 具有全部
    大文件的历史数据, 可完全脱离 remote bup repo 来工作. 但缺点是, 在流程上更繁琐,
    且存在本地重复存储.

- 仍需解决的问题:
  bup 作为 remote 使用时, 需要解决产生大量分支的问题. 这既是不必要的、混乱的
  (为什么不能在 push 到 bup 时指定保存的分支?), 长期使用又会有潜在问题 (当一个 bup
  中达到数千个分支时会有效率问题).
  一个临时的解决办法是, 单独为每个 git annex repo 创建一个 bup remote repo. 只用来
  存储这个 annex repo 的大文件.


使用何种方式来记录笔记
======================
- Webpage

  * toolchain:
    producer: HTML + CSS + Javascript
    render: browser

- PDF

  * toolchain:
    producer: (La)TeX
    render: PDF viewer

- Plain text

  * toolchain:
    producer: markdown + reStructedText
    render: None

- Word document

  * toolchain:
    producer: Microsoft Word Processor
    render: Microsoft Word Processor

webpage 是面向显示器的, 具有适应性; pdf 是面向纸张和印刷的, 具有精确性.

个人电脑的选择
==============
- 不选择带有 Broadcom wireless network card 的机器. 它的 Linux 驱动不太好.


数据库及存储的选择
==================

PostgreSQL (RDBMS)
------------------


MongoDB (NoSQL)
---------------

Elasticsearch (search engine)
-----------------------------
- 明显优点
  1. 完全基于分布式的理念而设计. ES 中的各种操作都考虑到了分布式所带来的问题 (节点同步、更新冲突等),
     es 多节点之间涉及的问题很大程度上都能够自动化地解决, 对用户只暴露出十分简单、方便的 API 和配置.
  2. 匹配度概念和模糊搜索. ES 中每个 field 都可以建立 inverted index, 经过 tokenization + analysis
     (分词和分析) 等操作, 一个 field 的值分成多个 token, 在 inverted index 中出现多次. 对搜索输入也
     做相同的操作, 从而允许计算匹配程度.
  3. 内存占用小. es 的各种 index 定时 flush 到硬盘上. 内存中只保留比如半个小时的索引数据.

- 缺点
  1. 搜索语法费劲.
  2. 有点慢. (因为不占内存?)

Password Management
===================
- 1Password

  * 不提供官方的 linux 客户端. 浏览器插件需要本地有客户端存在才能运行.
    这导致它完全不能在 linux 中使用.

- Keeper

  * linux 客户端 too lousy to use. 可以当作不存在.

  * 浏览器插件可以单独使用.

- Enpass

  * linux 客户端是这几种中做得最好的.

  * 桌面版免费, 移动版按照设备收费.

- 结论

  * 暂时尝试使用 Enpass. 若没问题, 则付费持续使用.

  * 若 1Password 出 linux 版, 则切过去.
