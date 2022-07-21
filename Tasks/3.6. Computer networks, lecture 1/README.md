   Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"
   
   1. Работа c HTTP через телнет.

      Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80
      отправьте HTTP запрос
      
   GET /questions HTTP/1.0
   HOST: stackoverflow.com
   [press enter]
   [press enter]
      
      В ответе укажите полученный HTTP код, что он означает?

   Решение:

   vagrant@vagrant:$ telnet stackoverflow.com 80
   Trying 151.101.129.69...
   Connected to stackoverflow.com.
   Escape character is '^]'.
   GET /questions HTTP/1.0
   HOST: stackoverflow.com
   
   HTTP/1.1 301 Moved Permanently
   cache-control: no-cache, no-store, must-revalidate
   location: https://stackoverflow.com/questions
   x-request-guid: 331383fa-e5fb-406f-a86a-fa2c40c9b8ed
   feature-policy: microphone 'none'; speaker 'none'
   content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
   Accept-Ranges: bytes
   Date: Thu, 21 Jul 2022 14:07:38 GMT
   Via: 1.1 varnish
   Connection: close
   X-Served-By: cache-fra19125-FRA
   X-Cache: MISS
   X-Cache-Hits: 0
   X-Timer: S1658412458.431450,VS0,VE88
   Vary: Fastly-SSL
   X-DNS-Prefetch-Control: off
   Set-Cookie: prov=3c95a43b-e735-b556-8ff1-fb4fff7416cb; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly
   
   Connection closed by foreign host.
   
   HTTP/1.1 301 Moved Permanently - это код перенаправления. Означает, что запрошенный ресурс был перемещён в URL,
                                    указанный в заголовке Location: https://stackoverflow.com/questions.
   
   2. Повторите задание 1 в браузере, используя консоль разработчика F12.
       
       откройте вкладку Network
       отправьте запрос http://stackoverflow.com
       найдите первый ответ HTTP сервера, откройте вкладку Headers
       укажите в ответе полученный HTTP код.
       проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
       приложите скриншот консоли браузера в ответ.

   Решение: (Страница была загружена за 1.01 сек)
   
   Request URL: http://stackoverflow.com/
   Request Method: GET
   Status Code: 307 Internal Redirect
   Referrer Policy: strict-origin-when-cross-origin
   Cross-Origin-Resource-Policy: Cross-Origin
   Location: https://stackoverflow.com/
   Non-Authoritative-Reason: HSTS
   Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
   Upgrade-Insecure-Requests: 1
   User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36
   
   Код перенаправления 307 Temporary Redirect означает, что запрошенный ресурс был временно перемещён в URL-адрес,
   указанный в заголовке Location (https://stackoverflow.com/).
   Метод и тело исходного запроса повторно используются для выполнения перенаправленного запроса.
   
   PrintScr по ссылке в решении ДЗ.

   3. Какой IP адрес у вас в интернете?
 
   Решение: Мой IP: 179.43.145.251

   4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois.

   Решение: (Провайдер: Simple Carrier Transit Customers, AS51852.)

   vagrant@vagrant:$ whois -h whois.radb.net 179.43.145.251
   route:      179.43.128.0/18
   origin:     AS51852
   descr:      Simple Carrier Transit Customers
   admin-c:    jamespradopl
   tech-c:     jamespradopl
   mnt-by:     MAINT-AS42624
   changed:    david@simplecarrier.net 20200416  #17:01:01Z
   source:     RADB
   
   route:          179.43.145.0/24
   descr:          ROUTE OBJECT
   origin:         AS51852
   mnt-by:         KP73900-MNT
   created:        2014-04-03T15:16:17Z
   last-modified:  2018-09-04T17:53:13Z
   source:         RIPE-NONAUTH
   remarks:        ****************************
   remarks:        * THIS OBJECT IS MODIFIED
   remarks:        * Please note that all data that is generally regarded as personal
   remarks:        * data has been removed from this object.
   remarks:        * To view the original object, please query the RIPE Database at:
   remarks:        * http://www.ripe.net/whois
   remarks:        ****************************
   
   person:     James Prado
   address:    Panama City Panama
   phone:      +507 6624-7555
   e-mail:     admin@privatelayer.com
   nic-hdl:    jamespradopl
   mnt-by:     MAINT-AS42624
   changed:    david@simplecarrier.net 20200413  #01:13:18Z
   source:     RADB

   5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS?
      Воспользуйтесь утилитой traceroute.

   Решение:

   vagrant@vagrant:$ traceroute -AnI 8.8.8.8
   traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
   1  10.0.2.2 [*]  0.340 ms  0.329 ms  0.328 ms
   2  10.173.0.1 [*]  55.906 ms  148.487 ms  148.187 ms
   3  179.43.146.109 [AS51852]  147.854 ms  148.305 ms  148.718 ms
   4  185.227.149.8 [AS43440]  146.914 ms  147.338 ms  147.032 ms
   5  185.227.149.17 [AS43440]  147.442 ms  147.133 ms  147.539 ms
   6  184.104.204.249 [AS6939]  147.047 ms  62.979 ms  152.851 ms
   7  80.81.193.108 [*]  152.189 ms  65.403 ms  159.069 ms
   8  108.170.251.193 [AS15169]  158.332 ms  157.172 ms  156.529 ms
   9  142.250.46.245 [AS15169]  156.735 ms  156.034 ms  156.627 ms
   10  8.8.8.8 [AS15169]  154.200 ms * *

   6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?

   Решение: наибольшая задержка - AS???    80.81.193.108

   vagrant@vagrant:$ mtr -zn 8.8.8.8
   vagrant (10.0.2.15)                                                            2022-07-21T15:21:30+0000
   Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                            Packets               Pings
   Host                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
   1. AS???    10.0.2.2                                                     0.0%    26    0.9   1.2   0.8   2.1   0.3
   2. AS???    10.173.0.1                                                   0.0%    26   57.2  62.4  52.2 164.5  25.8
   3. AS51852  179.43.146.109                                               0.0%    26   54.2  61.2  52.5 146.6  21.7
   4. AS43440  185.227.149.8                                                0.0%    25   89.2  64.8  53.6 144.7  21.6
   5. AS43440  185.227.149.17                                               0.0%    25   64.4  72.2  62.4 144.6  19.9
   6. AS6939   184.104.204.249                                              0.0%    25   64.9  76.7  62.9 151.4  24.3
   7. AS???    80.81.193.108                                                0.0%    25   63.8  80.5  62.3 155.6  29.3
   8. AS15169  108.170.251.193                                              0.0%    25   64.8  75.1  62.9 144.7  24.9
   9. AS15169  142.250.46.245                                               0.0%    25   65.4  74.3  64.5 144.8  22.6
   10. AS15169  8.8.8.8                                                      0.0%    25   63.8  77.2  62.9 147.8  26.3               


   7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig.

   Решение:

   vagrant@vagrant:$ dig +short NS dns.google
   ns3.zdns.google.
   ns2.zdns.google.
   ns1.zdns.google.
   ns4.zdns.google.

   vagrant@vagrant:$ dig +short A dns.google
   8.8.4.4
   8.8.8.8

   8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig.

   Решение:

   vagrant@vagrant:$ dig +noall +answer -x 8.8.8.8
   8.8.8.8.in-addr.arpa.   631     IN      PTR     dns.google.
   vagrant@vagrant:$ dig +noall +answer -x 8.8.4.4
   4.4.8.8.in-addr.arpa.   86400   IN      PTR     dns.google.
