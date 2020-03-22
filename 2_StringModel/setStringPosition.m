function string = setStringPosition(string, stringLength, stringAngle, stringOrigin)
% Sebastian J. Schlecht, Friday, 20 March 2020

[sx,sy] = pol2cart(stringAngle, stringLength);

string.origin = stringOrigin;
excite_pos = string.origin + [0 sx; 0 sy];

string.x = @(xi) excite_pos(1,1) + xi*( excite_pos(1,2) - excite_pos(1,1));
string.y = @(xi) excite_pos(2,1) + xi*( excite_pos(2,2) - excite_pos(2,1));


string.mid.x = string.x(0.5);
string.mid.y = string.y(0.5);
string.l = norm([string.x(0) - string.x(1); string.y(0) - string.y(1)]);
