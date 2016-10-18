%{--
  - Copyright (c) 2014 University of Hawaii
  -
  - This file is part of DataCenter metadata (DCmd) project.
  -
  - DCmd is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - DCmd is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with DCmd.  It is contained in the DCmd release as LICENSE.txt
  - If not, see <http://www.gnu.org/licenses/>.
  --}%

<%@  page import="edu.hawaii.its.dcmd.inf.GeneralService" %>
<%
    def genService = grailsApplication.classLoader.loadClass('edu.hawaii.its.dcmd.inf.GeneralService').newInstance()
%>

<r:require modules='select2' />

<script>
    $(document).ready(function() {
        $("#softwareTechSelect").select2({
            placeholder: 'Please Select...',
            maximumInputLength: 20,
            width:150,

            /***************************************************************************************************************************************************************
             * In order to allow select to allow multiple select then uncomment multople:true and maximumSelectionLength: to allow a max number of selection.
             * We did not set them, because when multiple is true, the data return from the select are not correct in that the data return is a combination of the id.
             * i.e. if id 1 and 2 are chosen, 1,2 is return and since that id doesnt exist, it makes a new software technology with the name 1,2.
             **************************************************************************************************************************************************************/
            //multiple: true,
            //maximumSelectionLength: 3,

            createSearchChoice:function(term, data) { if ($(data).filter(function() { return this.text.localeCompare(term)===0; }).length===0) {return {id:term, text:term};} },
            initSelection: function(element, callback) {
                var data = {id: "${objectInstance?.softwareTech?.id}", text: "${objectInstance?.softwareTech.toString()}"};
                callback(data);
            },
            data: [${genService.listSoftwareAsSelect()}]
        }).select2('val', '0');

    });

</script>


<input type="hidden" name="softwareTechSelect" id="softwareTechSelect" />
