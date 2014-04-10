% Bibtex `theseuqam' - Luigi Santocanale et
% Gisele Legault, 16 nov 1998.
% construit sur le style `apalike'.
% Changements:
% 1) On a enleve' les parentheses pour l'anne'e
% apres le nom de l'auteur.
% 2) On ne repete pas le nom de l'auteur
% i.e. format.authors a ete copie' de siam.bst.
% 3) francisation des termes
% 4) modifie format.title.article
% pour ecrire le titre de l'article entre guillemets francais
% 5) modifie format.number.series
% pour ecrire la collection suivi du numero. Ex. Coll. Schaumm no. 12
% 6) creation de format.in.coll.booktitle
%    pour ecrire la la collection dans le style article et l'editeur
% 7) modifie format.lab.names
%    pour qu'il ecrive et al. apres le troisieme auteur
% 7) modifie format.pages
%    pour qu'il rajoute ~ entre p. et les no. de pages
% 19 mai 2004
% 9) creation de output.check.publisher et output.nonull.publisher
% pour ecrire l'adresse : editeur
% 20 janvier 2005
% 10) ajouter add.period$ dans les Function(article,book,booklet,inbook,incollection,
%     inproccedings,manual,masterthesis,misc,phdthesis,proceeding,techreport,unpublished)
%     pour qu'un point apparaisse apres le dernier nom des auteurs
% 8 novembre 2011
% 11) creation des type d'entree electronic, webpage, database et software
% 12) ajoute les champs url, urldate, support et basetitre
% 13) creation de write.url 
% 14) creation de write.consulte qui contient la date a laquelle la page web a ete consulte
% 15) creation de write.site_web qui contient le titre du site
% 16) creation de format.support et format.basetitre qui ecrit le support et
%     le nom de la base de donnees s'il y a lieu
% 17) creation de format.names.editeur qui écrit les noms des editeurs sous la forme P. Nom, P2. Nom2 et P3. Nom3 
%     creation de format.editors.conf qui ecrit 'sous la dir. de' s'il y a lieu dans le cas d'actes de colloque ou conference
% 18) modification de format.in.ed.booktitle qui inverse le booktitle et les editeurs 
% 19) modification de masterthesis et phdtehesis pour integrer le support 
% 20) creation de web.key.label qui cree l'etiquette a partir de l'auteur
%     ou du titre de la page web s'il n'y a pas d'auteur
% 21) modifie calc.label pour faire l'etiquette correctement avec
%     les nouveaux types webpage et electronic
% 22) Correction de Pierre Auger: modifier format.names pour ajouter une "," lorsqu'il ne reste 
%     que 2 auteurs.
%     mis et~al. en italique
% 23) ajouter author.title.sort pour trier les pages web et les bases de donnes par titre lorsqu'il 
%     n'y a pas d'auteur.
%     Modifie presort pour tenir compte des pages web et des databases dans l'ordre de tri.
      


ENTRY
  { address
    author
    basetitre
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    keywords
%    month      not used in apalike
    note
    number
    organization
    pages
    publisher
    school
    series
    support
    title
    type
    Url
    urldate
    volume
    year
  }
  {}
  { label extra.label sort.label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
    output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
    { add.period$ write$
      newline$
      "\newblock " write$
    }
    { output.state before.all =
        'write$
        { add.period$ " " * write$ }
      if$
    }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}
FUNCTION {output.nonnull.publisher}
{ 's :=
  output.state mid.sentence =
    { ": " * write$ }
    { output.state after.block =
    { add.period$ write$
      newline$
      "\newblock " write$
    }
    { output.state before.all =
        'write$
        { add.period$ " " * write$ }
      if$
    }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output.nonnull.point}
{ 's :=
  output.state mid.sentence =
    { ". " * write$ }
    { output.state after.block =
    { add.period$ write$
      newline$
      "\newblock " write$
    }
    { output.state before.all =
        'write$
        { add.period$ " " * write$ }
      if$
    }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{  duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.point}
{ duplicate$ empty$
    'pop$
    'output.nonnull.point
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.check.point}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull.point
  if$
}

FUNCTION {output.check.publisher}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull.publisher
  if$
}


%                   apalike needs this function because
%                   the year has special punctuation;
%                   apalike ignores the month

% elimine les parantheses dans la construction de l'annee
% de la fonction output.year.check

FUNCTION {output.year.check}
{ year empty$
    { "empty year in " cite$ * warning$ }
    { write$
      " " year * extra.label * "" *
      mid.sentence 'output.state :=
    }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  "]{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.deux.points}
{ address missing$
    'skip$
    {": " write$ }
  if$
}
FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
    'skip$
    { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
   { namesleft numnames =
     {s nameptr "{vv~}{ll}{, jj}{, f.}" format.name$ 't := }  % last name first
     {s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=}
     if$
     nameptr #1 >
    { namesleft #1 >
        { ", " * t * }
        { numnames #2 =
        { "," * }
        'skip$
          if$
          t "others" =
        { " \textit{et~al}" * }
        { " et " * t * }     %en francais
          if$
        }
      if$
    }
   't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.names.editeur}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
      {s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
    { namesleft #1 >
        { ", " * t * }
        { numnames #2 =
        { "" * }
        'skip$
          if$
          t "others" =
        { " \textit{et~al}" * }
        { " et " * t * }     %en francais
          if$
        }
      if$
    }
   't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

% ne repete pas le nom de l'auteur s'il apparait plus d'une fois dans
% la bibliographie
% last.authors,init.last.authors, format.authors ont ete copie' de siam.bst

STRINGS { last.authors }

FUNCTION {init.last.authors}
{ "" 'last.authors :=
}

FUNCTION {scapify}
{ duplicate$ empty$
    { pop$ "" }
    { "{\sc " swap$ * "}" * }
  if$
}

FUNCTION {format.authors}
{ author empty$
    { "" 'last.authors :=
      ""
    }
    { author last.authors =
       {"--------"}
       { author format.names }
        if$
      author 'last.authors :=
    }
  if$
}


FUNCTION {format.key}           % this function is just for apalike
{ empty$
    { key field.or.null }
    { ""}
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
    { ", \'{e}diteurs" * }    % en francais
    { ", \'{e}diteur" * }     % en francais
      if$
    }
  if$
}

FUNCTION {format.editors.conf}
{ editor empty$
    { "" }
    { " sous la dir. de " editor format.names.editeur *} 
      if$
}


FUNCTION {write.url}
{ URL empty$
    { skip$ }
    { " \textless \url{" URL * "}\textgreater." * write$ newline$ }
  if$
}

FUNCTION {write.consulte}
{ urldate empty$
    { skip$ }
    { " Consult{\'e} le " urldate *  "." * write$ newline$ }
  if$
}

FUNCTION {write.site_web}
{ journal empty$
    { skip$ }
    { " In " journal emphasize * "journal" output.check }
  if$
}



FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$ }
  if$
}


%Permet d'ecrire le titre de l'article entre guillements francais

FUNCTION {format.title.article}
{ title empty$
    { "" }
    { "\og " title "t" change.case$ * "\fg " *}
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
    { t #1 #2 substring$ "--" = not
        { "--" *
          t #2 global.max$ substring$ 't :=
        }
        {   { t #1 #1 substring$ "-" = }
        { "-" *
          t #2 global.max$ substring$ 't :=
        }
          while$
        }
      if$
    }
    { t #1 #1 substring$ *
      t #2 global.max$ substring$ 't :=
    }
      if$
    }
  while$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

% Modifie le format du volume, affiche T.12 plutot que volume 12
%
FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { new.block
      "T." volume tie.or.space.connect            % conforme UQAM
      series empty$
    'skip$
    { ", s\'{e}rie " * series emphasize * }    % en francais
      if$
      "volume and number" number either.or.check
    }
  if$
}

% Ecrit le Nom de la collection, suivi du numero
%
FUNCTION {format.number.series}
{ volume empty$
    {series empty$
    { "there's a number but no series in " cite$ * warning$ }
    { ". Coll. \og " * series * "\fg" *}
     if$
         number empty$
    { "" }
    { "no"           % en francais
    number tie.or.space.connect}
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
    { edition "l" change.case$ " \'{e}dition" * }    % en francais
    { edition "t" change.case$ " \'{e}dition" * }    % en francais
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
    { #1 'multiresult := }
    { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

% ecrit p. plutot que page
%
FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
    { "p.~" pages n.dashify * }
    { "p.~" pages * }
      if$
    }
  if$
}



FUNCTION {format.volume}
{ volume empty$
  {""}
  {" vol.~" volume *}
  if$
}

FUNCTION {format.volume.cap}
{ volume empty$
  {""}
  {" Vol.~" volume *}
  if$
}

FUNCTION {format.support}
{ support empty$
    { "" }
    { " " support *}
  if$
}

FUNCTION {format.basetitre}
{ basetitre empty$
    { skip$ }
    { basetitre  "." * write$}
  if$
}

FUNCTION {format.number}
{ number empty$
  {""}
  {" no.~" number *}
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
    { "chapitre" }                 % en francais
    { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
    'skip$
    { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
    { "In " booktitle emphasize * }
    { "In " booktitle emphasize * ", " * format.editors.conf * }
      if$
    }
  if$
}

FUNCTION {format.in.coll.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
    { "Coll. \og " booktitle * "\fg" * }
    { "Coll. " format.editors * ", Coll. \og " * booktitle emphasize * "\fg" *
}
      if$
    }
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Rapport" }               %en francais
    'type
  if$
  number empty$
    { "t" change.case$ }
    {" no.~" *  number tie.or.space.connect }  % rajoute " no.~" *
  if$
}

FUNCTION {format.article.crossref}
{ "In"                          % this is for apalike
  " \cite{" * crossref * "}" *
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "In "
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  "\cite{" * crossref * "}" *               % this is for apalike
}

FUNCTION {format.incoll.inproc.crossref}
{ "In"                          % this is for apalike
  " \cite{" * crossref * "}" *
}


FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title.article "title" output.check.point
  crossref missing$
    { journal emphasize "journal" output.check.point
      format.support  output.point
      support empty$
      {format.volume  output}
      {format.volume.cap output.point}
      if$
      volume empty$
      {format.number  output.point}
      {format.number output}
      if$
      format.pages  output
    }
    { format.article.crossref output.nonnull
      format.pages output
  }
  if$
  new.block
  note output
  fin.entry
  format.basetitre
  write.url new.block
  write.consulte
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
    { "author and editor" editor either.or.check }
    'skip$
      if$
    }
  if$
  add.period$
  output.year.check             % special for apalike
  new.block
  format.btitle "title" output.check
  format.support  output.point
  crossref missing$
    { format.bvolume output
      format.number.series output
      new.sentence
      address output
      publisher "publisher" output.check.publisher
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  new.block
  note output
  fin.entry
  format.basetitre
  write.url new.block
  write.consulte

}

FUNCTION {software} { book }

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title "title" output.check
  new.block
  howpublished output
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
    { "author and editor" editor either.or.check }
    'skip$
      if$
    }
  if$
  add.period$
  output.year.check             % special for apalike
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
      address output
      publisher "publisher" output.check.publisher
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.btitle "title" output.check
  new.block
  crossref missing$
    { format.in.coll.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      address output
      publisher "publisher" output.check.publisher
      format.edition output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title.article "title" output.check
  new.block
  crossref missing$
    { 
      format.in.ed.booktitle "booktitle" output.check
      format.support  output.point
      format.bvolume output
      format.number.series output
      format.pages output
      address output                    % for apalike
      new.sentence                  % there's no year
      organization output               % here so things
      publisher output                  % are simpler
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
  format.basetitre
  write.url new.block
  write.consulte

}

FUNCTION {conference} { inproceedings }


FUNCTION {manual}
{ output.bibitem
  format.authors output
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.btitle "title" output.check
  organization address new.block.checkb
  organization output
  address output
  format.edition output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title.article "title" output.check
  new.block
  support empty$
  {"M\'{e}moire de ma\^{\i}trise" format.thesis.type output.nonnull}
  {support "u" change.case$ "EN LIGNE" =
  {"M\'{e}moire de ma\^{\i}trise en ligne" format.thesis.type output.nonnull}
  {"M\'{e}moire de ma\^{\i}trise sur " support * format.thesis.type output.nonnull}
  if$}
  if$
  address output
  school "school" output.check
  new.block
  note output
  fin.entry
  format.basetitre
  write.url new.block
  write.consulte
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title output
  new.block
  howpublished output
  new.block
  format.support  output.point
  note output
  fin.entry
  format.basetitre
  write.url new.block
  write.consulte

}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title.article "title" output.check
  new.block
  support empty$
  {"Th\`{e}se de Doctorat" format.thesis.type output.nonnull}
  {support "u" change.case$ "EN LIGNE" =
  {"Th\`{e}se de Doctorat en ligne" format.thesis.type output.nonnull}
  {"Th\`{e}se de Doctorat sur " support * format.thesis.type output.nonnull}
  if$}
  if$
  address output
  school "school" output.check
  new.block
  note output
  fin.entry
  format.basetitre
  write.url new.block
  write.consulte
}

FUNCTION {proceedings}
{ output.bibitem
  format.editors output
  editor format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address output                % for apalike
  new.sentence                  % we always output
  organization output               % a nonempty organization
  publisher output              % here
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  new.block
  note output
  fin.entry
}



FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  fin.entry
}
FUNCTION {electronic}
{ output.bibitem
  format.authors "author" output.check
  author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  format.title.article "title" output.check
  
  crossref missing$
    { journal emphasize "journal" output.check
    }
    { format.article.crossref output.nonnull
    }
  if$
  new.block
    note output
    format.support  output.point
  fin.entry
  
  write.url new.block
  write.consulte 
  }
  
FUNCTION {webpage}
{ output.bibitem
  author empty$
      {format.title.article "title" output.check
      title format.key output}
      {format.authors "author" output.check
      journal format.key output}
  if$
  %author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  author empty$ 
    'skip$
    {format.title.article "title" output.check}
  if$  
  new.block
  note output
  write.site_web
  format.support  output.point
  fin.entry
  
  write.url new.block
  write.consulte 
}

FUNCTION {database}
{ output.bibitem
  author empty$
      {format.btitle "title" output.check
      title format.key output}
      {format.authors "author" output.check
      journal format.key output}
  if$
  %author format.key output              % special for
  add.period$
  output.year.check                 % apalike
  new.block
  author empty$ 
    'skip$
    {format.btitle "title" output.check}
  if$  
  new.block
  note output
  format.volume.cap output.point
  format.number output
  write.site_web
  format.support  output.point
  editor output.point
  fin.entry
  
  write.url new.block
  write.consulte 
}


FUNCTION {default.type} { book }

MACRO {jan} {"Janvier"}

MACRO {feb} {"F\'{e}vrier"}

MACRO {mar} {"Mars"}

MACRO {apr} {"Avril"}

MACRO {may} {"Mai"}

MACRO {jun} {"Juin"}

MACRO {jul} {"Juillet"}

MACRO {aug} {"Ao\^{u}t"}

MACRO {sep} {"Septembre"}

MACRO {oct} {"Octobre"}

MACRO {nov} {"Novembre"}

MACRO {dec} {"D\'{e}cembre"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

% PROVIENT de chicago.bst
% format.lab.names:
%
% determines "short" names for the abbreviated author information.
% "Long" labels are created in calc.label, using the routine my.full.label
% to format author and editor fields.
%
% There are 4 cases for labels.   (n=3 in the example)
% a) one author             Foo
% b) one to n               Foo, Bar and Baz
% c) use of "and others"    Foo, Bar et al.
% d) more than n            Foo et al.
%

FUNCTION {format.lab.names}
{ 's :=
  s num.names$ 'numnames :=
  numnames #3 >    % change number to number of others allowed before
           % forcing "et al".
    { s #1 "{vv~}{ll}" format.name$ " et~al." * }
    {
      numnames #1 - 'namesleft :=
      #2 'nameptr :=
      s #1 "{vv~}{ll}" format.name$
    { namesleft #0 > }
    { nameptr numnames =
        { s nameptr "{ff }{vv }{ll}{ jj}" format.name$ "others" =
        { " et~al." * }
        { " et " * s nameptr "{vv~}{ll}" format.name$ * }
          if$
        }
        { ", " * s nameptr "{vv~}{ll}" format.name$ * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
      while$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
    { cite$ #1 #3 substring$ }
    'key                    % apalike uses the whole key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key                % apalike uses the whole key
      if$
    }
    { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.label}
{ editor empty$
    { key empty$
    { cite$ #1 #3 substring$ }
    'key            % apalike uses the whole key, no organization
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {web.key.label}
{   
    author empty$
    { key empty$
    { title}
    'key            % apalike uses the whole key, no organization
      if$
    }
    { author format.lab.names }
    
  if$
}

FUNCTION {calc.label}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.label   
         {type$ "webpage" =
          type$ "database" =
          or
         'web.key.label
         'author.key.label  }         % for labeling and sorting
      if$
     if$
    }
  if$
  ", "                          % these three lines are
  *                         % for apalike, which
  type$ "webpage" =
  type$ "electronic" =
  or
  {year field.or.null #-1 #4 substring$}      % uses all four digits
  {year field.or.null purify$ #-1 #4 substring$}      % uses all four digits
  if$
  *
  'label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
    { "   " * }
    'skip$
      if$                       % apalike uses initials
      s nameptr "{vv{ } }{ll{ }}{  f{ }}{  jj{ }}" format.name$ 't := % <= here
      nameptr numnames = t "others" = and
    { "et al" * }
    { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
    { "to sort, need author or key in " cite$ * warning$
      ""
    }
    { key sortify }
     if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
    { key empty$
        { "to sort, need author, editor, or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}


FUNCTION {author.title.sort}
{ author empty$
    { title empty$
     { key sortify}  
      {title sort.format.names}
      if$
    }    
    {  author sort.format.names }
  if$
}

FUNCTION {editor.sort}
{ editor empty$
    { key empty$
    { "to sort, need editor or key in " cite$ * warning$
      ""
    }
    { key sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

%           apalike uses two sorting passes; the first one sets the
%           labels so that the `a's, `b's, etc. can be computed;
%           the second pass puts the references in "correct" order.
%           The presort function is for the first pass. It computes
%           label, sort.label, and title, and then concatenates.

FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
       'editor.sort
       { type$ "webpage" =
         type$ "database" =
         or
          'author.title.sort   
          'author.sort
        if$
      }
    if$
    }
  if$
  #1 entry.max$ substring$  % for
  'sort.label :=        % apalike
  sort.label            % style
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT        % by label, sort.label, title---for final label calculation

STRINGS { last.label next.extra }   % apalike labels are only for the text;

INTEGERS { last.extra.num }     % there are none in the bibliography

FUNCTION {initialize.extra.label.stuff} % and hence there is no `longest.label'
{ #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'last.extra.num :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  label extra.label * 'label :=
  extra.label 'next.extra :=
}

EXECUTE {initialize.extra.label.stuff}

ITERATE {forward.pass}

REVERSE {reverse.pass}

%               Now that the label is right we sort for real,
%               on sort.label then year then title.  This is
%               for the second sorting pass.
FUNCTION {bib.sort.order}
{ sort.label
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {bib.sort.order}

SORT        % by sort.label, year, title---giving final bibliography order

FUNCTION {begin.bib}
{ preamble$ empty$              % no \etalchar in apalike
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{}" write$ newline$       % no labels in apalike
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
