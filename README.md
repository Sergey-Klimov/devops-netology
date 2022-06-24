# Доработанное решение домашнего задания к занятию «2.4. Инструменты Git»

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.
   	
	Применил комманду:

	$ git log --oneline aefea

	aefead220 Update CHANGELOG.md
	c12ad38c5 Merge pull request #25277 from hashicorp/alisdair/fix-terraform-version-version
	.
	.
	.	
	.
	
	В первой строке вывода - aefead220

	Далее выполнил комманду:

	$ git show aefead220
	commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
	Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
	Date:   Thu Jun 18 10:29:58 2020 -0400

    	Update CHANGELOG.md

	Ответ: полный хеш и комментарий коммита, который начинается на `aefea`: aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md

2. Какому тегу соответствует коммит `85024d3`?

	Применил комманду:

	$ git show 85024d3
	commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
	Author: tf-release-bot <terraform@hashicorp.com>
	Date:   Thu Mar 5 20:56:10 2020 +0000

   	v0.12.23

	Ответ: коммит `85024d3` соответствует тегу v0.12.23.

3. Сколько родителей у коммита `b8d720`? Напишите их хеши.

	Применил комманду:

	$ git show b8d720
	commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
	Merge: 56cd7859e 9ea88f22f
	Author: Chris Griggs <cgriggs@hashicorp.com>
	Date:   Tue Jan 21 17:45:48 2020 -0800

   	Merge pull request #23916 from hashicorp/cgriggs01-stable

    	[Cherrypick] community links

	В выводе комманды видим, что был сделан merge. Родители:56cd7859e05c36c06b56d013b55a252d0bb7e158 и 9ea88f22fc6269854151c571162c5bcf958bee2b

	Ответ: у коммита `b8d720` два родителя.


4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.

	
	Применил комманду:

	$ git log --pretty=format:"%H %s" v0.12.23..v0.12.24
	33ff1c03bb960b332be3af2e333462dde88b279e v0.12.24
	b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
	3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
	6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
	5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
	06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
	d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
	4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
	dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
	225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release
	
	Ответ:между тегами v0.12.23 и v0.12.24 8 комитов:

                	   Хэш	                        Комментарий
	b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
	3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
	6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
	5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
	06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
	d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
	4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
	dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md

	
5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
   так `func providerSource(...)` (вместо троеточего перечислены аргументы).

	Применил комманду: 
	
	$ git log -S 'func providerSource' --pretty=format:"%h, %an, %ad, %s"
	5af1e6234, Martin Atkins, Tue Apr 21 16:28:59 2020 -0700, main: Honor explicit provider_installation CLI config when present
	8c928e835, Martin Atkins, Thu Apr 2 18:04:39 2020 -0700, main: Consult local directories as potential mirrors of providers
	
	Первый коммит в котором была создана функция `func providerSource`:

	$ git show 8c928e835
	commit 8c928e83589d90a031f811fae52a81be7153e82f
	Author: Martin Atkins <mart@degeneration.co.uk>
	Date:   Thu Apr 2 18:04:39 2020 -0700

	Ответ: коммит в котором была создана функция `func providerSource` - 8c928e83589d90a031f811fae52a81be7153e82f

6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

	Применил комманду:

	$ git log -S globalPluginDirs --oneline
	125eb51dc Remove accidentally-committed binary
	22c121df8 Bump compatibility version to 1.3.0 for terraform core release (#30988)
	35a058fb3 main: configure credentials from the CLI config file
	c0b176109 prevent log output during init
	8364383c3 Push plugin discovery down into command package

	Ответ: получил 5 коммитов в которых была изменена функция `globalPluginDirs`.


7. Кто автор функции `synchronizedWriters`? 

	Применил комманду:

	$ git log -S synchronizedWriters --oneline
	bdfea50cc remove unused
	fd4f7eb0b remove prefixed io
	5ac311e2a main: synchronize writes to VT100-faker on Windows
	
	Первый комит, где встречается функции `synchronizedWriters` 5ac311e2a.
	Далее выполнил комманду:

	$ git show 5ac311e2a

	Получил:	

	commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
	Author: Martin Atkins <mart@degeneration.co.uk>
	Date:   Wed May 3 16:25:41 2017 -0700

    	
	Ответ: автор функции `synchronizedWriters`- Martin Atkins.
