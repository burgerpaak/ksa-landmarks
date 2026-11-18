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
        s=box(68,40,164,132)+windows(82,57,4,1,15,16,35)
        s+=box(101,78,100,74,'accent',25,-17)
        for x in range(111,200,12):s+=line(x,79,x,151,'fine')
        for y in range(88,151,12):s+=line(102,y,200,y,'fine')
        return s+arrow('M52 133L98 120')
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
        s=path('M26 128Q52 112 75 55Q99 111 145 128Q100 145 26 128Z','accent')
        s+=line(75,55,75,164,'line')+line(26,128,26,164,'line')+line(145,128,145,164,'line')
        s+=path('M179 100Q225 49 279 100Q225 145 179 100Z','glass')+line(179,100,279,100,'dash')
        return s
    if key=='truss':
        s=path('M22 82L143 82L143 118L22 118ZM22 118L52 82L83 118L113 82L143 118','heavy')
        s+=line(28,119,28,162,'line')+line(137,119,137,162,'line')
        s+=rect(185,38,91,123,'base')
        for y in [38,99]:s+=path(f'M185 {y+61}L230 {y}L276 {y+61}M185 {y}L230 {y+61}L276 {y}','heavy')
        return s
    if key=='podium':
        return box(103,34,81,104)+windows(118,49,3,4,12,11,22,23)+box(49,137,202,36,'accent')
    if key=='bridge':
        return box(45,47,61,118)+box(209,35,58,130)+box(104,83,106,18,'accent',12,-8)
    if key in ('twist','taper'):
        if key=='taper':
            return poly('80,164 117,32 199,32 238,164','base')+poly('117,32 142,20 221,20 199,32','light')+poly('199,32 221,20 261,151 238,164','shade')+line(80,177,238,177,'dimension')+line(117,18,199,18,'dimension')
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
    'membrane': ('PTFE 원단의 한 예', 'ETFE 쿠션의 한 예'),
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
