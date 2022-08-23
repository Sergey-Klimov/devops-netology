# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 #тут должен быть адрес, например: "71.78.22.40"
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43" #добавил кавычки
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time
import json
import yaml

ipaddress = {
    'yandex.ru': '0',
    'mail.ru': '0',
    'google.com': '0'
}
for item in ipaddress:
    initial_addr = socket.gethostbyname(item)
    ipaddress[item] = initial_addr
    with open(item + '.json', 'w') as output_json:
        data_json = json.dumps({item: ipaddress[item]})
        output_json.write(data_json)
    with open(item + '.yaml', 'w') as output_yaml:
        data_yaml = yaml.dump([{item: ipaddress[item]}])
        output_yaml.write(data_yaml)

while True:
    for item in ipaddress:
        old_addr = ipaddress[item]
        new_addr = socket.gethostbyname(item)
        if new_addr != old_addr:
            ipaddress[item] = new_addr
            with open(item + '.json', 'w') as output_json:
                data_json = json.dumps({item: ipaddress[item]})
                output_json.write(data_json)
            with open(item + '.yaml', 'w') as output_yaml:
                data_yaml = yaml.dump([{item: ipaddress[item]}])
                output_yaml.write(data_yaml)
            print("[ERROR] " + item + " IP mismatch: old IP " + old_addr + ", new IP " + new_addr)
        print(item + " - " + ipaddress[item])
    print("____________________________________________")
    time.sleep(10)
```

### Вывод скрипта при запуске при тестировании:
```
[ERROR] yandex.ru IP mismatch: old IP 77.88.55.60, new IP 77.88.55.88
yandex.ru - 77.88.55.88
[ERROR] mail.ru IP mismatch: old IP 94.100.180.201, new IP 217.69.139.200
mail.ru - 217.69.139.200
google.com - 142.250.150.138
____________________________________________
yandex.ru - 77.88.55.88
mail.ru - 217.69.139.200
google.com - 142.250.150.138
____________________________________________
yandex.ru - 77.88.55.88
mail.ru - 217.69.139.200
google.com - 142.250.150.138
____________________________________________
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"yandex.ru": "5.255.255.77"}
{"mail.ru": "94.100.180.201"}
{"google.com": "142.250.150.139"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- yandex.ru: 5.255.255.77
- mail.ru: 94.100.180.201
- google.com: 142.250.150.139
```