update gralperiodos
set estado = 'I'
where aplicacion in ('CXP', 'INV')
and final <= '2005-1-1'
and compania = '03'