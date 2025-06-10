function distance = Haversine(lat1, lon1, lat2, lon2)
    % 将经纬度从度数转换为弧度
    lat1 = deg2rad(lat1);
    lon1 = deg2rad(lon1);
    lat2 = deg2rad(lat2);
    lon2 = deg2rad(lon2);

    % 地球半径（单位：公里）
    r = 6371;

    % 计算纬度差和经度差
    deltaLat = lat2 - lat1;
    deltaLon = lon2 - lon1;

    % Haversine 公式
    a = sin(deltaLat / 2)^2 + cos(lat1) * cos(lat2) * sin(deltaLon / 2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1 - a));

    % 计算距离
    distance = r * c;
end