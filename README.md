# Домашнее задание к занятию "«Отказоустойчивость в облаке» - `Смирнов Максим`

### Задание 1

`Ссылка на основоной terraform файл`

https://github.com/turboturtle-90/Fault_tolerance_cloud_/blob/b27ac354e901dfbae47928a56792ad5d20d895eb/vms.tf

`Работающий балансировщик и статус хостов`

![balancer_group_status.jpg](https://github.com/turboturtle-90/Fault_tolerance_cloud_/blob/3a11948fa2ce091a88f4759247fadc01256af029/balancer_group_status.jpg)

`Ответ балансировщика в обращении к нему (на стандартном порту 80)`

![balancer_request.jpg](https://github.com/turboturtle-90/Fault_tolerance_cloud_/blob/3a11948fa2ce091a88f4759247fadc01256af029/balancer_request.jpg)

`Установка Nginx производилась атоматически с использованием Ansible. Текст плейбука ниже`
```                                                         
---
- name: Установка и настройка Nginx
  hosts: webservers
  become: yes
  tasks:
    - name: Обновить кэш apt и установить nginx
      apt:
        name: nginx
        state: latest
        update_cache: yes
      
  
    - name: Убедиться, что nginx запущен и добавлен в автозагрузку
      service:
        name: nginx
        state: started
        enabled: yes
```

