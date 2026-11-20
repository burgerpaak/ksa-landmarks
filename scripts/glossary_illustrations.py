"""Schematic architectural teaching diagrams; not measured landmark drawings."""
from html import escape
from math import cos, sin, radians


def rect(x, y, w, h, cls='base', extra=''):
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" class="{cls}" {extra}/>'


def path(d, cls='line', extra=''):
    return f'<path d="{d}" class="{cls}" {extra}/>'


def line(x, y, xx, yy, cls='line'):
    return path(f'M{x} {y}L{xx} {yy}', cls)


def poly(points, cls='base'):
    return f'<polygon points="{points}" class="{cls}"/>'


def circle(x, y, r, cls='base'):
    return f'<circle cx="{x}" cy="{y}" r="{r}" class="{cls}"/>'


def box(x, y, w, h, cls='base', dx=24, dy=-16):
    return (poly(f'{x},{y} {x+dx},{y+dy} {x+w+dx},{y+dy} {x+w},{y}', 'light')
            + poly(f'{x+w},{y} {x+w+dx},{y+dy} {x+w+dx},{y+h+dy} {x+w},{y+h}', 'shade')
            + rect(x, y, w, h, cls))


def windows(x, y, cols=4, rows=3, w=13, h=12, gx=22, gy=24):
    return ''.join(rect(x+i*gx, y+j*gy, w, h, 'glass') for i in range(cols) for j in range(rows))


def arrow(d):
    return path(d, 'arrow', 'marker-end="url(#ARROW)"')


def arches(x=45, y=68, n=4, width=52, height=84):
    out=''
    for i in range(n):
        a=x+i*width
        # A filled spandrel above each opening, with shared supporting piers.
        out+=path(f'M{a} {y-12}H{a+width}V{y+height}H{a+width-8}'
                  f'V{y+38}Q{a+width/2} {y-10} {a+8} {y+38}'
                  f'V{y+height}H{a}Z','accent')
    return out


def bowl(open_front=False):
    # Seat bands surround an open pitch. Roofs are deliberately omitted.
    out='<ellipse cx="160" cy="99" rx="116" ry="65" class="accent"/>'
    out+='<ellipse cx="160" cy="99" rx="96" ry="51" class="line"/>'
    out+='<ellipse cx="160" cy="99" rx="78" ry="38" class="line"/>'
    out+='<ellipse cx="160" cy="99" rx="61" ry="28" class="paper"/>'
    out+=rect(116,81,88,36,'pitch')+line(160,81,160,117,'fine')
    if open_front:
        out+=poly('110,125 149,119 192,128 208,178 105,178','paper')
        out+=line(111,132,105,160,'heavy')+line(194,135,208,160,'heavy')
        out+=arrow('M159 180L159 143')
    else:
        out+=arrow('M271 173L240 141')
    return out


def drawing(key):
    if key=='lintel':
        s=path('M61 44H259V169H211V111H109V169H61Z','base')
        for y in [64,84]:s+=line(62,y,258,y,'fine')
        for x in [94,160,226]:s+=line(x,44,x,64,'fine')
        for x in [127,193]:s+=line(x,64,x,84,'fine')
        s+=rect(87,91,146,20,'accent')
        s+=arrow('M160 22L160 43')
        s+=arrow('M98 119L98 145')+arrow('M222 119L222 145')
        return s
    if key=='clerestory':
        # A continuous stepped roof: glazing is in the vertical rise,
        # above the lower roof, rather than a dormer pasted onto it.
        s=rect(50,125,200,48)
        s+=poly('250,125 274,94 274,155 250,173','shade')
        s+=rect(74,54,200,40)
        s+=rect(84,62,180,24,'accent')
        for x in [88,123,158,193,228]:s+=rect(x,66,31,16,'glass')
        s+=poly('50,125 250,125 274,94 74,94','light')
        s+=poly('50,125 250,125 250,130 50,130','base')
        s+=poly('250,125 274,94 274,99 250,130','shade')
        s+=poly('68,49 280,49 292,40 80,40','light')
        s+=rect(68,49,212,5)
        s+=poly('280,49 292,40 292,45 280,54','shade')
        return s+arrow('M32 68L81 74')
    if key=='fascia':
        # Pitched roof on supporting walls. Only the vertical eaves board
        # is accented; roof covering, side edge and soffit stay neutral.
        s=rect(64,119,162,57)
        s+=poly('226,119 250,65 274,105 274,154 226,176','shade')
        s+=windows(102,139,3,1,25,27,39)
        s+=poly('48,112 234,112 254,52 68,52','light')
        s+=poly('234,112 254,52 282,100 282,106 254,58 234,118','base')
        s+=poly('48,124 234,124 226,130 64,130','shade')
        s+=rect(48,112,186,12,'accent')
        return s+arrow('M28 151L90 119')
    if key=='najdi':
        s=box(44,75,210,88,'warm')
        for x in range(44,252,24): s+=rect(x,64,13,12,'warm')
        s+=windows(65,93,6,1,7,14,29)+rect(134,125,30,38,'shade')
        s+=arrow('M44 38L71 87')
        return s
    if key=='adobe':
        s=''
        for j in range(3):
            for i in range(3):
                x=48+i*69+(j%2)*10;y=65+j*29
                s+=box(x,y,65,26,'warm',14,-9)
                for k in range(3):s+=line(x+12+k*15,y+7,x+16+k*15,y+12,'grain')
        return s
    if key=='rawshan':
        # The bay projects toward the viewer from the wall plane. A cap,
        # panel frames and separate screened lower panels articulate the woodwork.
        s=box(90,37,154,137,dx=20,dy=-14)
        for x in [98,174]:
            s+=poly(f'{x},153 {x+24},137 {x+24},147 {x},164','shade')
        s+=box(82,74,118,73,'accent',24,-16)
        for x in [89,125,161]:
            s+=rect(x,80,31,31,'light')
            for y in [86,92,98,104]:s+=line(x+2,y,x+29,y,'fine')
            s+=rect(x,119,31,21,'light')
            for xx in range(x+6,x+30,6):s+=line(xx,120,xx,139,'fine')
            for y in [125,132]:s+=line(x+1,y,x+30,y,'fine')
        s+=poly('205,79 219,69.7 219,128.3 205,137.7','light')
        for y in [87,96,105,114,123]:s+=line(205,y,219,y-9.3,'fine')
        s+=box(78,147,126,6,'accent',24,-16)
        s+=box(77,67,128,7,'accent',24,-16)
        return s+arrow('M37 107L78 107')
    if key in ('sandstone','stucco'):
        s=box(72,47,163,113,'warm' if key=='sandstone' else 'base')
        if key=='sandstone':
            for j in range(6):s+=path(f'M75 {64+j*15}Q115 {51+j*15} 159 {66+j*15}T232 {61+j*15}','grain')
        else:
            s+=rect(75,50,158,106,'plaster')
            s+=poly('206,119 251,99 267,124 220,147','accent')
            s+=line(245,123,275,151,'heavy')
        return s
    if key=='minaret':
        s=box(61,125,119,40)+path('M80 125A40 40 0 0 1 160 125','base')
        s+=rect(216,70,22,95,'accent')+poly('213,69 219,47 235,47 241,69','accent')
        s+=rect(208,90,39,8,'accent')+rect(216,99,23,10,'accent')
        s+=path('M219 47Q227 17 235 47','accent')+line(227,31,227,17,'line')
        return s
    if key=='muqarnas':
        s=path('M44 158L44 72Q160-8 276 72L276 158','base')
        for row in range(4):
            n=7-row;w=27;x=160-n*w/2;y=63+row*25
            for i in range(n):
                a=x+i*w
                s+=path(f'M{a} {y}L{a+27} {y}L{a+24} {y+19}Q{a+13.5} {y+34} {a+3} {y+19}Z','accent' if row%2 else 'warm')
                s+=poly(f'{a},{y} {a+13.5},{y+11} {a+3},{y+19}', 'light')
                s+=poly(f'{a+27},{y} {a+13.5},{y+11} {a+24},{y+19}', 'shade')
        return s
    if key in ('arcade','riwaq'):
        s=''
        if key=='riwaq':
            s+=poly('42,56 77,30 297,30 262,56','light')
            s+=poly('42,152 77,128 297,128 262,152','shade')
            s+=line(77,30,77,128,'line')+line(297,30,297,128,'line')
        s+=arches(42,68,4,55)
        return s
    if key in ('courtyard','atrium'):
        s=poly('56,72 56,132 183,180 183,120','base')+poly('183,120 271,72 271,132 183,180','shade')
        # Clip the sunken floor and inner walls to the opening. They must not
        # paint over the opaque front walls of the building.
        s+=f'<defs><clipPath id="gloss-court-{key}"><polygon points="97,75 145,49 229,79 180,105"/></clipPath></defs>'
        s+=f'<g clip-path="url(#gloss-court-{key})">'
        s+=poly('97,75 145,49 229,79 180,105','pitch')
        s+=poly('97,75 145,49 145,75 97,101','light')
        s+=poly('145,49 229,79 229,105 145,75','shade')+'</g>'
        s+=poly('56,72 143,25 145,49 97,75','light')
        s+=poly('143,25 271,72 229,79 145,49','light')
        s+=poly('271,72 183,120 180,105 229,79','light')
        s+=poly('183,120 56,72 97,75 180,105','light')
        if key=='atrium':
            s+=poly('97,75 145,49 229,79 180,105','glass')
            s+=line(121,62,204.5,92,'fine')+line(138.5,90,187,64,'fine')
        else:s+=arrow('M160 15L160 88')
        return s
    if key=='windtower':
        s=box(61,132,182,38)+box(128,44,49,94,'warm')
        s+=rect(133,49,14,30,'shade')+rect(155,49,14,30,'shade')
        s+=arrow('M38 55C66 44 90 70 137 62')+arrow('M151 76L151 144L198 144')
        return s
    if key in ('facade','ribbon','fin','louver','exoskeleton','crown'):
        s=box(72,43,151,122,'accent' if key=='facade' else 'base')
        if key!='ribbon':s+=windows(85,61,5,4,13,14,27,25)
        if key=='facade':return s
        if key=='ribbon':
            for y in [64,94,124]:s+=rect(73,y,148,15,'glass')
        if key=='fin':
            for x in range(79,225,23):s+=poly(f'{x},45 {x+12},37 {x+12},159 {x},167','accent')
        if key=='louver':
            for y in range(54,160,20):s+=poly(f'64,{y} 219,{y} 234,{y-10} 79,{y-10}','accent')
        if key=='exoskeleton':
            for x in [67,223]:s+=rect(x,38,8,131,'accent')
            s+=path('M72 162L222 44M72 44L222 162M72 101L147 44L222 101L147 162Z','heavy')
        if key=='crown':
            s+=poly('72,44 82,25 104,39 146,14 185,39 213,26 223,44','accent')
        return s
    if key in ('curtain','cladding'):
        s=box(45,49,118,111)
        if key=='curtain':
            for x in [48,103,158]:s+=rect(x,50,6,109,'shade')
            for y in [49,103,151]:s+=rect(48,y,115,6,'shade')
        s+=poly('181,55 266,35 266,147 181,170','glass' if key=='curtain' else 'accent')
        for j in range(1,4):s+=line(181,55+j*28,266,35+j*28,'fine')
        s+=line(222,45,222,159,'fine')
        for y in [67,136]:s+=line(159,y,181,y-5,'line')
        return s
    if key=='lattice':
        s=''
        cols=[[34,58,93,139,196,270],[31,65,110,153,202,275],[36,69,101,143,198,270],[34,59,90,132,188,273]]
        nodes=[[(x,42+j*35+5*sin(i*.9+j*.4)) for i,x in enumerate(row)] for j,row in enumerate(cols)]
        for j in range(3):
            for i in range(5):
                cell=[nodes[j][i],nodes[j][i+1],nodes[j+1][i+1],nodes[j+1][i]]
                s+=poly(' '.join(f'{x:.1f},{y:.1f}' for x,y in cell),'accent' if (i+j)%3==0 else 'light')
        return s
    if key=='cantilever':
        s=rect(60,37,52,128,'shade')+box(105,72,155,12,'accent',0,0)
        s+=arrow('M240 32L240 68')
        return s+path('M118 162L267 162','dash')
    if key=='membrane':
        # Left: tensioned fabric canopy, mast and tied edges in exterior view.
        # Right: an inflated two-film cushion SECTION, with an empty air space.
        s=line(160,26,160,174,'fine')
        s+=line(81,40,81,170,'line')+rect(73,170,16,5,'base')
        s+=line(28,120,15,166,'line')+line(136,120,148,166,'line')
        s+=rect(9,166,12,6,'base')+rect(142,166,12,6,'base')
        s+=path('M28 120Q61 105 81 57Q104 105 136 120Q82 147 28 120Z','accent')
        s+=path('M81 57Q74 105 82 133','fine')
        s+=arrow('M35 115L9 139')+arrow('M128 115L152 139')
        # The blue boundaries are separate films, not a solid lens.
        s+=path('M181 100C202 54 276 54 297 100','line',
                'style="stroke:#538b99;stroke-width:3"')
        s+=path('M181 100C202 146 276 146 297 100','line',
                'style="stroke:#538b99;stroke-width:3"')
        s+=rect(176,92,9,16,'shade')+rect(293,92,9,16,'shade')
        s+=arrow('M239 93L239 70')+arrow('M239 107L239 130')
        s+=arrow('M211 95L202 81')+arrow('M267 105L276 119')
        return s
    if key=='truss':
        s=path('M22 82L143 82L143 118L22 118ZM22 118L52 82L83 118L113 82L143 118','heavy')
        s+=line(28,119,28,162,'line')+line(137,119,137,162,'line')
        s+=rect(185,38,91,123,'base')
        for y in [38,99]:s+=path(f'M185 {y+61}L230 {y}L276 {y+61}M185 {y}L230 {y+61}L276 {y}','heavy')
        return s
    if key=='podium':
        # Paint the terrace first so its rear edge never crosses the tower.
        s=box(44,144,210,35,'accent',48,-30)
        s+=windows(58,154,7,1,19,17,27)
        s+=box(120,40,70,90)+windows(130,53,3,4,11,11,20,19)
        return s
    if key=='bridge':
        s=box(48,50,52,124,dx=26,dy=-18)+windows(58,65,2,4,11,14,22,25)
        s+=box(108,90,122,22,'accent',14,-10)
        for x in [119,141,163,185,207]:s+=rect(x,95,17,12,'glass')
        # The nearer right tower masks the bridge end at its left wall.
        s+=box(220,37,52,137,dx=26,dy=-18)+windows(230,53,2,5,11,14,22,24)
        return s+arrow('M169 55L169 86')
    if key in ('twist','taper'):
        if key=='taper':
            s=poly('110,173 135,40 182,40 207,173','base')
            s+=poly('135,40 154,28 201,28 182,40','light')
            s+=poly('182,40 201,28 234,157 207,173','shade')
            for t in [.2,.4,.6,.8]:
                y=40+133*t;left=135-25*t;right=182+25*t
                s+=line(left,y,right,y,'fine')
                s+=line(right,y,201+33*t,28+129*t,'fine')
            for left,right,y in [(135,182,16),(110,207,187)]:
                s+=line(left,y,right,y,'dimension')
                s+=line(left,y-4,left,y+4,'dimension')
                s+=line(right,y-4,right,y+4,'dimension')
            return s
        levels=[]
        for i in range(11):
            a=radians(-18+i*5);pts=[]
            for x,y in [(-40,-32),(40,-32),(40,32),(-40,32)]:
                u=x*cos(a)-y*sin(a);v=x*sin(a)+y*cos(a)
                pts.append((160+u-v,154-i*12+(u+v)*.35))
            levels.append(pts)
        s=''
        for i in range(10):
            # Join corresponding corners, rather than stacking floating slabs.
            for side in [1,2]:
                cell=[levels[i][side],levels[i][side+1],levels[i+1][side+1],levels[i+1][side]]
                s+=poly(' '.join(f'{x:.1f},{y:.1f}' for x,y in cell),'shade' if side==1 else 'accent')
        s+=poly(' '.join(f'{x:.1f},{y:.1f}' for x,y in levels[-1]),'light')
        return s
    if key=='undercut':
        return box(93,108,130,56,'shade')+box(57,44,198,64,'base')+arrow('M40 156L92 132')
    if key=='portico':
        s=box(72,52,173,111)+rect(138,89,42,74,'shade')+box(59,88,172,12,'accent')
        for x in [68,117,166,215]:s+=rect(x,100,8,65,'accent')
        return s
    if key=='open-bowl':return bowl(True)
    if key=='full-bowl':return bowl(False)
    if key=='risalit':
        return box(51,54,202,105)+windows(66,77,7,3,12,13,27,26)+box(119,82,69,88,'accent',26,-27)+arrow('M225 182L185 161')
    if key=='pavilion':
        return path('M65 142L145 159L235 132','dash')+box(33,78,69,62)+box(133,38,64,63)+box(220,103,54,51)
    if key=='cornice':
        return box(74,71,164,91)+box(59,56,193,14,'accent')+poly('74,74 238,74 238,87 74,87','shade')+arrow('M37 35L72 58')
    if key=='scaffold':
        s=box(74,34,164,131)+windows(91,54,4,4,16,14,36,26)
        for x in [51,122,193,264]:s+=line(x,48,x,174,'heavy')
        for y in [62,110,158]:
            s+=line(45,y,272,y,'heavy')
            s+=path(f'M51 {y}L122 {y+48}M122 {y}L193 {y+48}M193 {y}L264 {y+48}','fine') if y<158 else ''
        for y in [107,155]:s+=rect(50,y,215,5,'accent')
        return s
    if key=='metal':
        s=rect(27,48,75,108,'accent')
        for i in range(12):
            x=121+i*6; y=48 if i%2==0 else 41; yy=41 if i%2==0 else 48
            s+=poly(f'{x},{y} {x+6},{yy} {x+6},{yy+108} {x},{y+108}','accent' if i%2==0 else 'shade')
        s+=rect(219,48,75,108,'accent')
        for x in range(229,288,15):
            for y in range(60,149,16):s+=circle(x,y,3,'paper')
        return s
    if key=='repeat':
        s=box(37,78,16,50,'accent',8,-8)+arrow('M82 101L126 101')
        for x in range(150,271,29):s+=box(x,78,16,50,'accent',8,-8)
        return s
    if key=='curved':
        s=path('M37 70L125 70L125 145L37 145Z','base')+arrow('M137 105L165 105')
        s+=path('M188 60Q227 96 281 48L281 126Q227 174 188 138Z','accent')
        for t in [.2,.4,.6,.8]:
            x=(1-t)**2*188+2*(1-t)*t*227+t*t*281
            y=(1-t)**2*60+2*(1-t)*t*96+t*t*48
            s+=line(round(x,2),round(y,2),round(x,2),round(y+78,2),'fine')
        return s
    if key=='luminous':
        s=box(44,49,111,115,'shade')+poly('184,53 266,34 266,149 184,168','glow')
        for x,y in [(132,73),(132,109),(132,145)]:
            s+=circle(x,y,5,'lamp')+arrow(f'M{x+6} {y}L226 {y-9}')
        return s
    if key=='scale':
        s=box(108,31,125,134)+windows(125,45,4,4,13,17,27,27)+rect(145,134,25,31,'shade')
        s+=circle(72,144,4,'accent')+line(72,149,72,161,'heavy')+path('M66 171L72 160L78 171M65 153L79 153','line')
        s+=rect(244,154,47,13,'accent')+circle(254,168,5,'shade')+circle(282,168,5,'shade')
        return s
    raise ValueError(f'No glossary illustration for {key}')


LABELS = {
    'lintel': ('개구부 위의 수평 구조 부재',),
    'clerestory': ('낮은 지붕 위의 수직 채광창',),
    'fascia': ('처마 끝의 전면 마감판',),
    'najdi': ('작은 창 · 두꺼운 흙벽',),
    'adobe': ('햇볕에 말린 흙벽돌',),
    'rawshan': ('돌출 깊이와 목재 격자',),
    'minaret': ('돔', '미나렛'),
    'muqarnas': ('겹쳐 내려오는 입체 셀',),
    'riwaq': ('아치 뒤로 이어지는 지붕 있는 통로',),
    'courtyard': ('지붕 없이 하늘로 열린 공간',),
    'windtower': ('바람받이 → 실내로 이어지는 공기 흐름',),
    'facade': ('강조된 외부 입면',),
    'curtain': ('주 구조', '유리 외피'),
    'louver': ('기울어진 차양판',),
    'lattice': ('규칙에 따라 변하는 연결 격자',),
    'exoskeleton': ('건물 바깥의 지지 골격',),
    'cantilever': ('고정단', '자유단과 하중 ↓'),
    'membrane': ('PTFE · 당겨 고정한 원단 (외관)', 'ETFE · 공기로 부푼 필름 (단면)'),
    'truss': ('삼각형 트러스', '다이아그리드'),
    'podium': ('넓은 저층 기단부',),
    'bridge': ('공중 연결부',),
    'twist': ('높이에 따라 회전하는 외피',),
    'taper': ('상부로 갈수록 좁아지는 폭',),
    'crown': ('몸통 위의 강조된 상부',),
    'atrium': ('유리 지붕으로 덮인 내부 공간',),
    'fin': ('벽면에서 돌출된 판',),
    'ribbon': ('연속된 수평 창 띠',),
    'undercut': ('상부보다 안쪽으로 물러난 하부',),
    'portico': ('기둥으로 받친 현관 지붕',),
    'open-bowl': ('관람석의 틈 · 지붕 생략',),
    'full-bowl': ('연속 관람석 · 지붕 생략',),
    'risalit': ('중앙 벽체의 돌출 깊이',),
    'pavilion': ('분리된 개별 동',),
    'arcade': ('기둥 사이로 반복되는 아치',),
    'cornice': ('돌출된 상부 마감 띠',),
    'scaffold': ('임시 골격과 작업 발판',),
    'cladding': ('바탕 벽', '외장 패널'),
    'metal': ('평판', '골판', '천공판'),
    'sandstone': ('입자와 자연 층리',),
    'stucco': ('바탕 위에 바르는 미장층',),
    'repeat': ('원본 모듈', '같은 모듈의 반복'),
    'curved': ('직선', '곡면 흐름'),
    'luminous': ('뒤쪽 광원', '반투명 외피'),
    'scale': ('사람', '출입구', '차량'),
}


def render_illustration(term):
    key=term['id']
    body=drawing(key).replace('url(#ARROW)',f'url(#gloss-arrow-{key})')
    labels=LABELS[key]
    caption=(f'<div class="gloss-legend" style="--legend-count:{len(labels)}">'
             + ''.join(f'<span>{escape(label)}</span>' for label in labels) + '</div>')
    return (f'<svg class="gloss-diagram" viewBox="0 0 320 200" role="img" '
            f'aria-labelledby="gloss-fig-{key}" xmlns="http://www.w3.org/2000/svg">'
            f'<title id="gloss-fig-{key}">{escape(term["kr"])} 개념도. {escape(term["focus"])}</title>'
            f'<defs><marker id="gloss-arrow-{key}" viewBox="0 0 8 8" refX="7" refY="4" '
            'markerWidth="5" markerHeight="5" orient="auto-start-reverse">'
            '<path d="M0 0L8 4L0 8Z" fill="#17786f"/></marker></defs>'
            '<g stroke-linejoin="round" stroke-linecap="round">'+body+'</g></svg>'+caption)
