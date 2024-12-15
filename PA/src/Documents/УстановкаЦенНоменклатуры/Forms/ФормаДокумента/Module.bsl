#Область ОбработчикиСобытийФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура Загрузить(Команда)

	Если Объект.ЦеныНоменклатуры.Количество() > 0 Тогда
		ТекстВопроса = НСтр(
			"ru = 'В таблице уже введены цены. При загрузке из файла таблица будет очищена. Продолжить?'");

		Ответ = Ждать ВопросАсинх(ТекстВопроса, РежимДиалогаВопрос.ДаНет);

		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Фильтр = НСтр("ru = 'Файл Excel|*.xlsx'");
	РезультатПомещения = Ждать ПоместитьФайлНаСерверАсинх(,,, ПараметрыДиалога); // ОписаниеПомещенногоФайла

	Если РезультатПомещения = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если РезультатПомещения.ПомещениеФайлаОтменено Тогда
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресФайла", РезультатПомещения.Адрес);

	Оповещение = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ФормаЗагрузкиИзФайла", ПараметрыФормы, , , , , Оповещение);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ЗагрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьЦеныИзВременногоХранилища(Результат);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьЦеныИзВременногоХранилища(Результат)
	Объект.ЦеныНоменклатуры.Загрузить(ПолучитьИзВременногоХранилища(Результат));
КонецПроцедуры



// Код процедур и функций

#КонецОбласти