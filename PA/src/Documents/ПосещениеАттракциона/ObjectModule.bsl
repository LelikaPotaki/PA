// @strict-types


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.АктивныеПосещения.Записывать = Истина;
	Движения.Записать();
	
	Выборка = АктивныеПосещения();
	ОсталосьПосещений = 0;
	ВидАттракционаАбонемента = Неопределено;
	Если Выборка.Следующий() Тогда
		ОсталосьПосещений = Выборка.КоличествоПосещений;
		ВидАттракционаАбонемента = Выборка.ВидАттракциона;
	КонецЕсли;
		
	Если ОсталосьПосещений < 1 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "В билете не осталось посещений.";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Основание";
		Сообщение.Сообщить();
	КонецЕсли;
	
	ВидАттракционаДокумента = ВидАттракциона(Аттракцион);
	Если ЗначениеЗаполнено(ВидАттракционаАбонемента) И ВидАттракционаДокумента <> ВидАттракционаАбонемента Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Билет не подходит для посещения этого аттракциона.";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Основание";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// регистр АктивныеПосещения
	Движения.АктивныеПосещения.Записывать = Истина;
	Движение = Движения.АктивныеПосещения.Добавить();
	Движение.Период = Дата;
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Основание = Основание;
	Движение.ВидАттракциона = ВидАттракционаАбонемента;
	Движение.КоличествоПосещений = 1;

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Активные посещения.
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//   *ВидАттракциона - СправочникСсылка.ВидыАттракционов
//   *КоличествоПосещений - Число
//
Функция АктивныеПосещения()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктивныеПосещенияОстатки.ВидАттракциона КАК ВидАттракциона,
		|	АктивныеПосещенияОстатки.КоличествоПосещенийОстаток КАК КоличествоПосещений
		|ИЗ
		|	РегистрНакопления.АктивныеПосещения.Остатки(, Основание = &Основание) КАК АктивныеПосещенияОстатки";
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат Выборка;
	
КонецФункции

Функция ВидАттракциона(Номенклатура)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Аттракционы.ВидАттракциона
	|ИЗ
	|	Справочник.Аттракционы КАК Аттракционы
	|ГДЕ
	|	Аттракционы.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Номенклатура);

	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ВидАттракциона;

КонецФункции

#КонецОбласти

#Область Инициализация

#КонецОбласти

#КонецЕсли
