{*
* 2007-2013 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2013 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

			</table>
			{if !$simple_header && $list_total > 20}
				<div class="table-pagination pull-right">
					<span>
					{if $page > 1}
						<input type="image" src="../img/admin/list-prev2.gif" onclick="getE('submitFilter{$table}').value=1"/>&nbsp;
						<input type="image" src="../img/admin/list-prev.gif" onclick="getE('submitFilter{$table}').value={$page - 1}"/>
					{/if}
						{l s='Page'} <b>{$page}</b> / {$total_pages}
					{if $page < $total_pages}
						<input type="image" src="../img/admin/list-next.gif" onclick="getE('submitFilter{$table}').value={$page + 1}"/>&nbsp;
						<input type="image" src="../img/admin/list-next2.gif" onclick="getE('submitFilter{$table}').value={$total_pages}"/>
					{/if}
					</span>

					<span>
						&nbsp;|&nbsp;
						<label >{l s='Display'}</label>
						<select class="filter fixed-width-xs" name="pagination" onchange="submit()">
							{* Choose number of results per page *}
							{foreach $pagination AS $value}
								<option value="{$value|intval}"{if $selected_pagination == $value} selected="selected" {elseif $selected_pagination == NULL && $value == $pagination[1]} selected="selected2"{/if}>{$value|intval}</option>
							{/foreach}
						</select>
					</span>
					<span> / {$list_total} {l s='result(s)'}</span>
				</div>
			{/if}
			{if $bulk_actions}
				<div class="row">
					{if $bulk_actions|count > 1}
						<div class="col-lg-11">
							<select id="select_submitBulk" name="select_submitBulk">
								{foreach $bulk_actions as $key => $params}
									<option value="{$key}">{$params.text}</option>
								{/foreach}
							</select>
						</div>
						<input type="submit" class="btn btn-primary" name="submitBulk" id="submitBulk" value="{l s='Apply'}" />
					{else}
						{foreach $bulk_actions as $key => $params}
							{if $key == 'affectzone'}
								<div class="col-lg-11">
									<select id="zone_to_affect" name="zone_to_affect">
										{foreach $zones as $z}
											<option value="{$z['id_zone']}">{$z['name']}</option>
										{/foreach}
									</select>
								</div>
							{/if}
							<input type="submit" class="btn btn-primary" name="submitBulk{$key}{$table}" value="{$params.text}" {if isset($params.confirm)}onclick="return confirm('{$params.confirm}');"{/if} />
						{/foreach}
					{/if}
				</div>
			{/if}
		</td>
	</tr>
</table>
<input type="hidden" name="token" value="{$token}" />
</fieldset>
</form>

<script type="text/javascript">
	var confirmation = new Array();
	{foreach $bulk_actions as $key => $params}
		{if isset($params.confirm)}
			confirmation['{$key}{$table}'] = "{$params.confirm}";
		{/if}
	{/foreach}

	$(document).ready(function(){
		{if $bulk_actions|count > 1}
			$('#submitBulk').click(function(){
				if (confirmation[$(this).val()])
					return confirm(confirmation[$(this).val()]);
				else
					return true;
			});
			$('#select_submitBulk').change(function(){
				if ($(this).val() == 'affectzone')
					loadZones();
				else if (loaded)
					$('#zone_to_affect').fadeOut('slow');
			});
		{/if}
	});
	var loaded = false;
	function loadZones()
	{
		if (!loaded)
		{
			$.ajax({
				type: 'POST',
				headers: { "cache-control": "no-cache" },
				url: 'ajax.php?rand=' + new Date().getTime(),
				data: 'getZones=true&token={$token}',
				async : true,
				cache: false,
				dataType: 'json',
				success: function(data) {
					var html = $(data);
					html.hide();
					$('#select_submitBulk').after(html);
					html.fadeIn('slow');
				}
			});
			loaded = true;
		}
		else
		{
			$('#zone_to_affect').fadeIn('slow');
		}
	}
</script>