#include 'protheus.ch'
#include 'fwmvcdef.ch'

//Fonte refeito Elcy Castro junior.

static cTitulo := "Cadastro Campanha"
user function zMVCMd3()
	local aArea   := getArea()
	local oBrowse := nil
	
	
	oBrowse := fwmBrowse():new()                                               // Instanciando FWMBrowse - Somente com dicionario de dados 
	oBrowse:setAlias("SZK")                                                    // Setando a tabela de cadastro de Autor/Interprete
	oBrowse:setDescription(cTitulo)                                            // Setando a descrição da rotina
	// Precisamos configurar as legendas depois [ver as regras]
	//oBrowse:addLegend("SBM->BM_PROORI == '1'", "GREEN",	"Original"     )
	//oBrowse:addLegend("SBM->BM_PROORI == '0'", "RED",	"Nao Original" )
	oBrowse:disableDetails()                                                   // Desativa o mostrar detalhes no rodape do mBrose 
	oBrowse:activate()
	
	restArea(aArea)
return nil


//-------------------------------------
//Geracao do menu superiorda mbrowse
//-------------------------------------
static Function MenuDef()
	local aRotina := {}
	
	add option aRotina title 'Visualizar' action 'VIEWDEF.zMVCMd3' OPERATION 2 ACCESS 0
	add option aRotina title 'Incluir'    action 'VIEWDEF.zMVCMd3' OPERATION 3 ACCESS 0
	add option aRotina title 'Alterar'    action 'VIEWDEF.zMVCMd3' OPERATION 4 ACCESS 0
	add option aRotina title 'Excluir'    action 'VIEWDEF.zMVCMd3' OPERATION 5 ACCESS 0	
return aRotina


//-------------------------------------
// Define a estrutura do ModelDef()
//-------------------------------------
static function modelDef()
	local oModel 	:= Nil
	local oStPai 	:= fwFormStruct(1,'SZK')
	local oStFilho 	:= fwFormStruct(1,'SZL')
	local aSZKRel	:= {}
	
	oModel := mpFormModel():new('zMVCMd3M')                                      // Criando o modelo e os relacionamentos 
	oModel:addFields('SZKMASTER',/*cOwner*/,oStPai)
	oModel:addGrid('SZLDETAIL','SZKMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  // 'cOwner' e para quem pertence
	
	// Rever mais amarracoes
	aSZKRel := {{'ZL_FILIAL', 'xFilial("SZL")'},;
				{'ZL_ID'    , 'ZK_ID' }}                                      // Fazendo o relacionamento entre o Pai e Filho

	oModel:setRelation('SZLDETAIL',aSZKRel,SZL->(indexKey(1)))                  // IndexKey -> quero a ordenacao e depois filtrado
	oModel:getModel('SZLDETAIL'):setUniqueLine({"ZL_FILIAL","ZL_ID"})	        // Nao repetir informacoes ou combinacoes {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:setPrimaryKey({'ZL_FILIAL', 'ZL_ID'})
	oModel:setDescription("Grupo de Produtos - Mod. 3")
	oModel:getModel('SZKMASTER'):setDescription('Dados Grupo')
	oModel:getModel('SZLDETAIL'):setDescription('Itens Grupo')
	oModel:GetModel( 'SZLDETAIL' ):SetUniqueLine( { 'ZL_PRODUTO' } )
return oModel


//-------------------------------------
// Define a estrutura do ViewDef()
//------------------------------------- 
static function viewDef()
	local oView	   := nil
	local oModel   := fwLoadModel('zMVCMd3')
	local oStPai   := fwFormStruct(2,'SZK')
	local oStFilho := fwFormStruct(2,'SZL')
	

	//criando a view
	oView := fwFormView():new()                                               
	oView:setModel(oModel)

	//adicionando os campos no cabe�alho e o grid dos fihos.
	oView:addField('VIEW_SZK',oStPai  ,'SZKMASTER')
	oView:addGrid('VIEW_SZL' ,oStFilho,'SZLDETAIL')
	
	//setanddo o dimensionamento de tamanho.
	oView:createHorizontalBox('CABEC',30)
	oView:createHorizontalBox('GRID' ,70)

	 // Amarrando a view com as box
	oView:setOwnerView('VIEW_SZK','CABEC')
	oView:setOwnerView('VIEW_SZL','GRID') 
	
	 // Habilitando título                    
	oView:enableTitleView('VIEW_SZK','Grupo')                                
	oView:enableTitleView('VIEW_SZL','Produtos')

return oView
