# 2CS - SIL1 - Projet Compile Cube Language 

Réalisation d’un mini compilateur 

Realise par : 

- Medjahdi Islem
- Moussaoui Abdelmouncif
- Habouche Khaled Abderrahmène
- Kenniche Abderrazak



2CS - SIL1 - 2023/2024 

[**1.Description du Language Cube**	](#_eup83vu9e19i)

[1.1 Commentaires	](#_osd1y9dpx9qf)

[1.2 Declarations	](#_xf5cagkl5657)

[1.2.1 Les types	](#_pdme2ruspwj3)

[1.2.2 Declaration des variables simple :	](#_8ddfzt1ns4ib)

[1.2.3 Declaration des variables structures :	](#_u3nw4fxeamt9)

[1.3 Les instructions de base :	](#_xrjdhf9g6rb6)

[1.3.1 Affectation :	](#_eo0ezh7h9rup)

[1.3.2 Condition :	](#_eqykiiw3709y)

[1.3.3 Boucles :	](#_t5h4o91th9nf)

[1.3.4 Les entrees / sorties :	](#_ydz435qje3xr)

[1.4 Les opérateurs :	](#_gvi56ledjhwc)

[1.4.1 Les opérateurs logiques :	](#_ntylqpj4lpum)

[1.4.2 Les opérateurs arithmétiques :	](#_bb2lp35sqbhj)

[1.4.3 Les opérateurs de comparaison :	](#_i94zilezkoie)

[1.4.4 Règles d'associativité :	](#_ejrmxn6aj04)
#













# <a name="_ugzc6dosfpr"></a><a name="_eup83vu9e19i"></a>**1.Description du Language Cube**
Un programme en Langage ***Cube*** se compose d'une séquence de déclarations et d'instructions.Chaque instruction doit occuper une seule ligne et se conclut par un point virgule ; Les blocs de code sont délimités par les mots-clés  { et  } .


## <a name="_osd1y9dpx9qf"></a>**1.1 Commentaires**
Un commentaire est précédé par un ‘#’. Il doit être ignoré par le compilateur.


|# This is a comment in Cube |
| :- |


## <a name="_xf5cagkl5657"></a>**1.2 Declarations** 
Une déclaration peut prendre la forme de variables simples telles que des *entiers*, des *réels*, des *caractères* ou des *booléens*, ainsi que de variables structurées telles que des *tableaux* ou des *enregistrements*.
###





### <a name="_a6hde26knfie"></a><a name="_pdme2ruspwj3"></a>**1.2.1 Les types** 


|**Type**|**Description**|` `**Plages de valeurs**|
| :- | :- | :- |
|Integer|Représente les nombres entiers.|[ -2147483648 , 2147483647 ]|
|Real|Représente les nombres réels.|[ -3.4\*10<sup>-38</sup> ,  3.4\*10<sup>38</sup> ]|
|Bool|Représente les valeurs de vérité |True ou  False|
|Char|Représente un seul caractère.|Un caractère ASCII valide|
|Text|Représente une chaîne de caractères ||

### <a name="_8ddfzt1ns4ib"></a>**1.2.2 Declaration des variables simple :** 


|Format|Example|
| :- | :- |
|**TYPE** variable\_name ;|Integer amount;|

Les noms de variables commencent par une lettre ou un trait de soulignement, et peuvent contenir des caractères alphanumériques ou underscores. 

Utilisez des guillemets pour entourer les chaînes de caractères. 

Évitez les mots réservés et les caractères spéciaux (!, @, #, $, %).
### <a name="_u3nw4fxeamt9"></a>**1.2.3 Declaration des variables structures :** 


|**Structure** |**Format**|**Example**|
| :- | :- | :- |
|*Tableau*|TYPE nom[size];|Integer a[4];|
|*Record*|<p>Record name : {{ </p><p>`    `TYPE Key;</p><p>}}</p>|<p>Record student : {{</p><p>`      `Integer age;</p><p>}}</p>|

La taille d’un tableau doit être un entier positif 

Pour accéder à un élément d’un tableau on utilise : table\_name[index] avec index compris entre 0 et size-1 

Pour accéder à un attribut d’un Record on utilise : record\_name.attribute\_name
## <a name="_xrjdhf9g6rb6"></a>**1.3 Les instructions de base :** 
### <a name="_eo0ezh7h9rup"></a>**1.3.1 Affectation :** 


|**Format**|**Example**|
| :- | :- |
|variable\_name = value ;|<p>x = 10; </p><p>student.age = 21;</p>|

### <a name="_eqykiiw3709y"></a>**1.3.2 Condition :** 


|**Format** |**Example**|
| :- | :- |
|<p>If ( condition ) {</p><p>`   `# instructions if true</p><p>} else {</p><p>`   `# instructions if false</p><p>}</p>|<p>If ( A > 10 ){</p><p>`    `A = A + 1;</p><p>} else {</p><p>`   `A = A - 1;</p><p>}</p>|

### <a name="_t5h4o91th9nf"></a>**1.3.3 Boucles :** 


|**Format** |**Example**|
| :- | :- |
|<p>Loop (init, condition , step){</p><p>`    `# instruction to repeat </p><p>}</p><p></p>|<p>Loop (i=0, i<10 , i=i+1) {</p><p>`    `Output(i);</p><p>}</p>|
|<p>While ( condition ) {</p><p>`    `# instructions to repeat</p><p>}</p>|<p>While( i < 10 ){</p><p>`    `Output(i);</p><p>}</p>|

On peut avoir des boucles imbriquées 

### <a name="_ydz435qje3xr"></a>**1.3.4 Les entrees / sorties :** 


|**Instruction**|**Example**|
| :- | :- |
|TYPE var\_name = Input(prompt);|Real x = Input(‘Enter a number’);|
|Output(value);|Output(“Hello World!”);|

## <a name="_gvi56ledjhwc"></a>**1.4 Les opérateurs :** 
### <a name="_ntylqpj4lpum"></a>**1.4.1 Les opérateurs logiques :** 


|**Operateur**|**Format**|**Example**|
| :- | :- | :- |
|AND|Expression1 and Expression2|(a>10) and ( isOk)|
|OR |Expression1 or Expression2|(a>10) or (isOk)|
|NOT|not (Expression) |not (a>10) |

L'associativité s'applique aux opérations  AND,OR .
### <a name="_bb2lp35sqbhj"></a>**1.4.2 Les opérateurs arithmétiques :** 


|**Operateur**|**Format**|**Example**|
| :- | :- | :- |
|**+**|Expression1 + Expression2|10 + A|
|**-**|Expression1 - Expression2|A - 2|
|**\***|Expression1 \* Expression2|(A+2) \* 5|
|**//**|<p>Expression1 // Expression2 </p><p># Expression2 <> zero</p>|A // 3|
|**%**|Expression1 % Expression2|A % 2 # modulo|

L'associativité s'applique aux opérations +  , \* 
### <a name="_i94zilezkoie"></a>**1.4.3 Les opérateurs de comparaison :** 


|**> , >= , < , <= , <> , ==**|
| :-: |

### <a name="_ejrmxn6aj04"></a>**1.4.4 Règles d'associativité :** 
Ce passage explique les priorités et les règles d'associativité dans l'évaluation des expressions mathématiques ou logiques.

1\. **Parenthèses** : Les opérations à l'intérieur des parenthèses ont la priorité la plus élevée et sont évaluées en premier.

2\. **Not** : L'opérateur logique "not" (négation logique) est appliqué ensuite.

3\. **And** : L'opérateur logique "and" (conjonction logique) a une priorité inférieure à "not" et est évalué après.

4\. **Or** : L'opérateur logique "or" (disjonction logique) est appliqué après "and".

5\. **Multiplication**, Division, Modulo : Ces opérations ont une priorité supérieure à l'addition et à la soustraction.

6\. **Addition**, **Soustraction** : Les opérations d'addition et de soustraction ont une priorité inférieure à la multiplication, à la division et au modulo.

7\. **Comparaisons** : Les opérations de comparaison (comme <, >, <=, >=, ==, <>) sont effectuées en dernier, ayant la priorité la plus basse.

En respectant ces règles, l'ordre d'exécution des opérations est déterminé dans une expression complexe, assurant une évaluation correcte et cohérente.
