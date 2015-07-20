begin work;
    update invparal
    set valor = 'S'
    where parametro = 'valida_existencias';
commit work;
