
# Проект CI CD приложения Kanban (Java Maven)

Данный репозиторий предназначен для размещения исходного java-приложения **Kanban** и файлов инфраструктуры Devops для организации процессов непрерывной интеграции и непрерывной доставки (CI/CD) на сервер исполнения. 

Приложение состоит из 2 частей:
 - Apache Tomcat файл с расширением .war
 - База данных PostgreSQL для хранения информации

Подробнее о приложении можно узнать из [файла описания](https://github.com/omichan/kanban/blob/diploma/README_orig.md).

## Описание процесса CI/CD
```mermaid
graph LR
A[Push / PR in *master] -- CI pl --> B[Docker HUB]
B -- CD pl --> D[Kubernetes]

```
 1. Разработчики вносят изменения в код приложения, создавая новые ветки в текущем репозитории и объединяют изменения в главную ветку **master**
 2. При возникновении событий **push** или **pull request** в ветку **master** запускается *Java CI with Maven* action, описанный в **Github Actions**. После успешного окончания CI-pipeline, запускается CD-pipeline *Kubernetes-deployment*.
 3. Артефакты успешной сборки публикуются в **Github Actions** и в реестре образов **[Docker Hub](https://hub.docker.com/r/lessoncodeby/kanban/tags)**
 4. В качестве версии артефактов сборки выступает уникальный номер успешной родительской задачи (*github.run_number*)
 5. Сборка CI-артефакта выполняется по **Dockerfile** из папки ./Docker/Dockerfile 
 6. CD-pipeline заключается в выполнении задач на self-runner хосте локального кластера Kubernetes. Задачи разворачивают на self-runner узел *k8s-runner* и через сервисный аккаунт выполняется обновление образа приложения **Kanban** в самом кластере **Kubernetes**.
 7. Установка Kubernetes-кластера выполняется на виртуальных машинах с помощью плейбука **Ansible** командой:  
 `ansible-playbook ./Ansible/playbook/create-cluster.yaml -i  ./Ansible/env/inventory`
 8. Первичная публикация приложения выполняется с помощью плейбука **Ansible** командой (*k8s_path* - переменная пути хранения kubernetes манифестов приложения)
 `ansible-playbook ./Ansible/playbook/deploy-kanban.yaml -i  ./Ansible/env/inventory -extra-vars "k8s_path=/home/user/kanban/k8s/"`
 9. В качестве системы мониторинга и логирования используется инструмент **Prometeus**. Манифесты развертывания **Prometeus** в кластере **Kubernetes** расположены в директории `./k8s-monitoring/prometeus-cfg/` . Формирование метрик для системы мониторинга выполняется специальным узлом postres-exporter , устанавливаемым в кластер kubernetes как отдельный от основной базы данных. Манифесты развертывания postres-exporter расположены в директории `./k8s-monitoring/postgres-cfg/`.
 10. В качестве дашборда отображения нагрузки на БД используется платформа **Grafana**. Манифест развертывания **Grafana** в кластере Kubernetes расположены в файле `./k8s-monitoring/grafana-config.yaml`

## Скриншоты
![Kanban app main](https://github.com/omichan/kanban/blob/diploma/readme/kanban-main.png)

![Grafana result](https://github.com/omichan/kanban/blob/diploma/readme/grafana-dash.png)



