local myname, ns = ...

local ICONSIZE, PADDING = 17, 2
local icons, texts = {}, {}
local indexes, ids = {}, {}

local function OnEnter(self)
    GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    GameTooltip:SetMerchantCostItem(indexes[self], ids[self])
end

local function OnLeave()
    GameTooltip:Hide()
    ResetCursor()
end

local function GetCurencyCount(item)
    if type(item) == 'string' then
        item = ns.currencyIds[item]
    end
    if not item then
        if item == ARENA_POINTS then
            item = Constants.CurrencyConsts.CLASSIC_ARENA_POINTS_CURRENCY_ID
        elseif item == CHAT_MSG_COMBAT_HONOR_GAIN then
            item = Constants.CurrencyConsts.CLASSIC_HONOR_CURRENCY_ID
        end
    end
    if not item then
        return 0
    end
    return C_CurrencyInfo.GetCurrencyInfo(item).quantity
end

local function GetQtyOwned(item)
    local id = ns.ids[item]
    if id then
        return GetItemCount(id, true) or 0
    end

    return GetCurencyCount(item) or 0
end

local function GetTextColor(price, link)
    if link and (GetQtyOwned(link) < price) then
        return '|cffff9999'
    end
    return ''
end

local function SetValue(self, i, j)
    indexes[self], ids[self] = i, j

    local texture, price, link, name = GetMerchantItemCostItem(i, j)
    if link == '' then
        link = nil
    end
    icons[self]:SetTexture(texture)
    texts[self]:SetText(GetTextColor(price, (link or name)) .. price)

    if (link or name) and ns.currencyIds[link or name] == Constants.CurrencyConsts.CLASSIC_HONOR_CURRENCY_ID then
        icons[self]:SetTexCoord(0.03125, 0.59375, 0.03125, 0.59375)
    else
        icons[self]:SetTexCoord(0, 1, 0, 1)
    end

    self:Show()
end

function ns.NewAltCurrencyItemFrame(parent)
    local frame = CreateFrame('Frame', nil, parent)
    frame:SetSize(ICONSIZE, ICONSIZE)

    local text = frame:CreateFontString(nil, nil, 'NumberFontNormalSmall')
    text:SetPoint('LEFT')
    texts[frame] = text

    local icon = frame:CreateTexture()
    icon:SetSize(ICONSIZE, ICONSIZE)
    icon:SetPoint('LEFT', text, 'RIGHT', PADDING, 0)
    icons[frame] = icon

    frame.SetValue = SetValue
    frame.SizeToFit = ns.SizeToFit

    frame:EnableMouse(true)
    frame:SetScript('OnEnter', OnEnter)
    frame:SetScript('OnLeave', OnLeave)

    return frame
end
