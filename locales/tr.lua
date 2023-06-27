local Translations = {
    error = {
        incorrect_amount = "Yanlış miktar",
        no_space = "Envanterde yeterli alan yok",
        no_slots = "Envanterde yeterli yuva yok",
        no_money = "Yetersiz bakiye",
        cant_give = "Item verilemiyor!",
        not_enough_item = "Bu itemden yeterince yok!"
    },
    target = {
        browse = "Markete Gözat",
    },
    menu = {
        close = "❌ Kapat",
        cost = "Maliyet: $",
        weight = "Ağırlık:",
        confirm = "Almayı Onayla",
        cpi = "Öğe başına maliyet:",
        payment_type = "Ödeme şekli",
        cash = "Nakit",
        card = "Kart",
        amount = "Alınacak miktar",
        submittext = "Öde",
        blackmoney = "Kara Para",
        crypto = "Q-Bit",
        amt = "Adet: "
     }
}

if GetConvar('qb_locale', 'en') == 'tr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
