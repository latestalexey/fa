﻿
Функция ПолучитьЦветИзСтроки(ЦветСтрокой) Экспорт
	
	ЦветПоУмолчанию = Новый Цвет;
	
	Результат = ЦветПоУмолчанию;
	
	Если НЕ ПустаяСтрока(ЦветСтрокой) Тогда
		Попытка
			Результат = СериализаторXDTO.XMLЗначение(Тип("Цвет"), ЦветСтрокой);
		Исключение
		    Результат = ЦветПоУмолчанию;
		КонецПопытки; 
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСтрокуИзЦвета(Цвет) Экспорт
	
	Возврат СериализаторXDTO.XMLСтрока(Цвет);
	
КонецФункции