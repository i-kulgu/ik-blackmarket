local Translations = {
    error = {
        incorrect_amount = "مبلغ غير صحيح",
        no_space = "لا يكفي مساحة في المخزون",
        no_slots = "لا توجد فتحات كافية في المخزون",
        no_money = "مال غير كاف",
        cant_give = "لا يمكن إعطاء عنصر",
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
     }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
