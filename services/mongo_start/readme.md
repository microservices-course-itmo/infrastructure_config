# Запуск mongodb
!Перед запуском необходимо установить переменную окружения MONGO_PASSWORD, которая будет использоваться как пароль пользователя root.

После запуска возможно подключиться к базе данных из другого контейнера в сети default_network по ссылке [mongodb://user:password@mongo:27017/database_name](mongodb://user:password@mongo:27017/database_name)