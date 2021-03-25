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

function gdpr_transform()
    local args = ngx.req.get_uri_args()
    -- Remove email_address param if present
    if args.email_address then
        args.email_address = nil
    end
    -- Trim lat/lng params
    if args.lat then
        args.lat = trim_to_3dp(args.lat)
    end
    if args.lng then
        args.lng = trim_to_3dp(args.lng)
    end
    -- Trim filter_lat/filter_lng params
    if args.filter_lat then
        args.filter_lat = trim_to_3dp(args.filter_lat)
    end
    if args.filter_lng then
        args.filter_lng = trim_to_3dp(args.filter_lng)
    end
    -- Trim geo point params (cll/ell)
    if args.cll then
        args.cll = trim_geo_point(args.cll)
    end
    if args.ell then
        args.ell= trim_geo_point(args.ell)
    end
    ngx.req.set_uri_args(args)
    local output = ngx.encode_args(args)
    ngx.var.modified_uri = ngx.var.uri .. "?" .. output
end

supported_countries = require "supported_countries"

-- Trim Lat/Lng and remove email for GDPR
gdpr_transform()

-- Escape all arguments
ngx.req.set_uri_args(ngx.req.get_uri_args())
