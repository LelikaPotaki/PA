#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура СформироватьНаСервере()
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлановыеОтсутствия.Сотрудник,
	|	ПлановыеОтсутствия.ДатаНачала,
	|	ПлановыеОтсутствия.ДатаОкончания,
	|	ПРЕДСТАВЛЕНИЕ(ПлановыеОтсутствия.Сотрудник) КАК СотрудникПредставление,
	|	ПлановыеОтсутствия.Регистратор
	|ИЗ
	|	РегистрСведений.ПлановыеОтсутствия КАК ПлановыеОтсутствия
	|ГДЕ
	|	ПлановыеОтсутствия.ДатаНачала < &КонецПериода
	|	И ПлановыеОтсутствия.ДатаОкончания > &НачалоПериода";

	Запрос.УстановитьПараметр("НачалоПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", Период.ДатаОкончания);

	Выборка = Запрос.Выполнить().Выбрать();

	ДиаграммаГанта.Очистить();
	Серия = ДиаграммаГанта.Серии.Добавить();
	Серия.Значение = "Отсутствия";
	Серия.Текст = "Отсутствия";

	ТочкиСотрудников = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Точка = ТочкиСотрудников.Получить(Выборка.Сотрудник);
		Если Точка = Неопределено Тогда
			Точка = ДиаграммаГанта.Точки.Добавить();
			Точка.Значение = Выборка.Сотрудник;
			Точка.Текст = Выборка.СотрудникПредставление;
			ТочкиСотрудников.Вставить(Выборка.Сотрудник, Точка);
		КонецЕсли;

		Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);

		Интервал = Значение.Добавить();

		Интервал.Начало = Выборка.ДатаНачала;
		Интервал.Конец = Выборка.ДатаОкончания;
		Интервал.Расшифровка = Выборка.Регистратор;

	КонецЦикла;
	
	ДиаграммаГанта.АвтоОпределениеПолногоИнтервала = Ложь;
	ДиаграммаГанта.УстановитьПолныйИнтервал(Период.ДатаНачала, Период.ДатаОкончания);

КонецПроцедуры
#КонецОбласти