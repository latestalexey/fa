﻿
Процедура ПроверитьУникальностьЗаписи(Запись, Регистратор, Отказ = Ложь)
	
	СтруктураИзмерений = Новый Структура; 
	Для Каждого МетаИзмерение Из Метаданные().Измерения Цикл
		ИмяИзмерения = МетаИзмерение.Имя;
		СтруктураИзмерений.Вставить(ИмяИзмерения, Запись[ИмяИзмерения]);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗначенияПоказателей.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.ЗначенияПоказателей КАК ЗначенияПоказателей
	|ГДЕ
	|	ЗначенияПоказателей.Регистратор <> &Регистратор
	|	И ЗначенияПоказателей.Период = &Период";
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.УстановитьПараметр("Период", Запись.Период);
	
	Для Каждого КлючИЗначение Из СтруктураИзмерений Цикл
		ИмяИзмерения = КлючИЗначение.Ключ;
		ЗначИзмерения = КлючИЗначение.Значение;
		Если ИмяИзмерения = "СтандартОтчетности" Тогда
			Запрос.Текст = Запрос.Текст + "
			|	И (ЗначенияПоказателей." + ИмяИзмерения + " = &" + ИмяИзмерения + " ИЛИ ЗначенияПоказателей." + ИмяИзмерения + " = ЗНАЧЕНИЕ(Справочник.СтандартыОтчетности.ПустаяСсылка))";
		Иначе
			Запрос.Текст = Запрос.Текст + "
			|	И ЗначенияПоказателей." + ИмяИзмерения + " = &" + ИмяИзмерения;
		КонецЕсли; 
		Запрос.УстановитьПараметр(ИмяИзмерения, ЗначИзмерения);
	КонецЦикла; 
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	СообщениеОбОшибке = "Для данного набора измерений значение показателя уже установлено документом " + Выборка.Регистратор + ": ";
	Для Каждого КлючИЗначение Из СтруктураИзмерений Цикл
		СообщениеОбОшибке = СообщениеОбОшибке + КлючИЗначение.Ключ + " = " + КлючИЗначение.Значение + "; ";
	КонецЦикла; 
	СообщениеОбОшибке = Лев(СообщениеОбОшибке, СтрДлина(СообщениеОбОшибке) - 2) + "!";

	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,,, Отказ);
	
КонецПроцедуры

Процедура ПроверитьПериодичностьЗаписи(Запись, Отказ)
	
	ЕстьПериодичность = ОбщегоНазначенияКлиентСервер.ПериодичностьУстановлена(Запись.Периодичность);
	
	Если Запись.Показатель.Периодический <> ЕстьПериодичность Тогда
		СообщениеОбОшибке = "Показатель """ + Запись.Показатель + """ не может быть записан для Периодичность = """ + Запись.Периодичность + """!";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,,, Отказ);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		ДатаНачПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(Запись.Период, Запись.Периодичность);
		Если Запись.Период <> ДатаНачПериода Тогда
			Запись.Период = ДатаНачПериода;
		КонецЕсли;
		Если Запись.Периодичность.Пустая() Тогда
			Запись.Периодичность = Перечисления.Периодичность.Нет;
		КонецЕсли;
		ПроверитьПериодичностьЗаписи(Запись, Отказ);		
		ПроверитьУникальностьЗаписи(Запись, Регистратор, Отказ);
	КонецЦикла; 
	
КонецПроцедуры
