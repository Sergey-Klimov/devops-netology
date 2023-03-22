## Данный плейбук позволяет установить clickhouse и vector

## Особенности
**/playbook/group_vars/** - переменные, которые можно при желании изменить (например версию ПО)  
**/inventory/prod.yml** - переменные хостов и параметров подключения  
**/templates** - шаблоны конфигурационных файлов  

# Команда для запуска:  
```
ansible-playbook -i inventory/prod.yml site.yml
```

## Примечание: playbook работает только с пакетным менеджером yum  

## Доработка
**/group_vars/clickhouse/vars.yml** - здесь переменные, отвечающие за кликхаус. Например мы можем поменять версию clickhouse_version: "22.3.3.44" на что-нибудь поновее, например или наоборот постарее https://packages.clickhouse.com/rpm/stable/ Таким образом мы избегаем хардкода и меняем в одном месте
clickhouse-client, clickhouse-server, clickhouse-common-static - имена пакетов (при переходе по ссылке выше можно проверить). Таким способом мы уменьшаем количество строк, поскольку используем цикл (with_items: "{{ clickhouse_packages }}") и тем самым добиваемся лучшей читабельности.  
**/group_vars/vector/vars.yml** - здесь переменные, отвечающие за вектор. vector_version: "0.21.1" - это версия вектора, а vector_config_dir: "{{ ansible_user_dir }}/vector_config/" и vector_config: это директории, которые будут созданы и где сгенерируется конфигурационный файл из джинжи темплейта  
