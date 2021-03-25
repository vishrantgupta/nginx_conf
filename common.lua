function has_value (tab, val)
    if not tab then
        return false
    end
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function split(s, pat)
    words = {}
    for word in string.gmatch(s, "([^"..pat.."]+)") do table.insert(words, word) end
    return words
end

function trim_to_3dp(lat_lng)
    return string.format("%.3f", lat_lng)
end

function trim_geo_point(geo_point)
    local lat_lng = split(geo_point, ",")
    if table.getn(lat_lng) ~= 2 then
        return nil
    end
    local lat = trim_to_3dp(lat_lng[1])
    local lng = trim_to_3dp(lat_lng[2])
    return lat .. "," .. lng
end
