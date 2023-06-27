local Translations = {
    error = {
        incorrect_amount = "مبلغ غير صحيح",
        no_space = "لا يكفي مساحة في المخزون",
        no_slots = "لا توجد فتحات كافية في المخزون",
        no_money = "مال غير كاف",
        cant_give = "لا يمكن إعطاء عنصر",
        not_enough_item = "There is not enough of this item amount!"
    },
    target = {
        browse = "تصفح المتجر",
    },
    menu = {
        close = "❌ اغلا",
        cost = "السعر: $",
        weight = "الحجم:",
        confirm = "تأكيد الشراء",
        cpi = "السعر/المنتوج:",
        payment_type = "نوع الدفع",
        cash = "كاش",
        card = "البنك",
        amount = "العدد",
        submittext = "دفع",
        blackmoney = "اموال قدرة",
        crypto = "Q-Bit",
        amt = "Amount: "
     }
}

if GetConvar('qb_locale', 'en') == 'ar' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
