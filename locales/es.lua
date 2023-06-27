local Translations = {
    error = {
        incorrect_amount = "Cantidad incorrecta",
        no_space = "No hay suficiente espacio en el inventario",
        no_slots = "No hay suficientes ranuras en el inventario",
        no_money = "No es suficiente dinero",
        cant_give = "No se puede dar el ítem!",
        not_enough_item = "There is not enough of this item amount!"
    },
    target = {
        browse = "Ver la tienda",
    },
    menu = {
        close = "❌ Cerrar",
        cost = "Costo: $",
        weight = "Peso:",
        confirm = "Confirmar compra",
        cpi = "Costo por ítem:",
        payment_type = "Tipo de pago",
        cash = "Efectivo",
        card = "Banco",
        amount = "Cantidad a comprar",
        submittext = "Pagar",
        blackmoney = "Plata Negra",
        crypto = "Q-Bit",
        amt = "Amount: "
     }
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
