# coding: Shift_JIS

require 'pathname'
require 'fileutils'
require 'vr/vruby'
require 'vr/vrdialog'
require 'vr/vrcontrol'

module TeXworksMod
	class SetForm < VRModalDialog
		def construct
			left,right,top,bottom = AbTeXinst::get_windowpos(hParent);
			move(left,top,420,360);
			@font = @screen.factory.newfont("�l�r �o�S�V�b�N",12);
			self.caption = 'TeXworks �ݒ�';
			addControl(VRCheckbox,'shortcutchk','TeXworks �̃V���[�g�J�b�g���f�X�N�g�b�v�ɍ쐬����',10,10,500,20);
			@shortcutchk.setFont(@font);
			addControl(VRStatic,'static','TeXworks ���p���ɖ��ߍ��ރt�H���g���w�肵�Ă��������D',10,40,500,20);
			@static.setFont(@font);
			addControl(VRRadiobutton,'default','�f�t�H���g�̎w����g���܂��D',20,60,500,20);
			@default.setFont(@font);
			addControl(VRRadiobutton,'msmingoth','msmingoth.map �i�l�r �����E�l�r �S�V�b�N��p���܂��D�j',20,80,500,20);
			@msmingoth.setFont(@font);
			addControl(VRRadiobutton,'hiragino','hiragino.map �i�q���M�m�����E�S�V�b�N Pro ��p���܂��D�j',20,100,500,20);
			@hiragino.setFont(@font);
			addControl(VRRadiobutton,'hiraginopron','hiraginopron.map �i�q���M�m�����E�S�V�b�N ProN ��p���܂��D�j',20,120,500,20);
			@hiraginopron.setFont(@font);
			addControl(VRRadiobutton,'ipaex','ipaex.map �iIPAex �t�H���g��p���܂��D�j',20,140,500,20);
			@ipaex.setFont(@font);
			addControl(VRRadiobutton,'kozuka','kozuka.map �i���˖����E�S�V�b�N Pro ��p���܂��D�j',20,160,500,20);
			@kozuka.setFont(@font);
			addControl(VRRadiobutton,'kozukapr6n','kozukapr6n.map �i���˖����E�S�V�b�N Pro6N ��p���܂��D�j',20,180,500,20);
			@kozukapr6n.setFont(@font);
			addControl(VRRadiobutton,'yu','yu.map �i�������E���S�V�b�N��p���܂� (Windows 8.1)�D�j',20,200,500,20);
			@yu.setFont(@font);
			addControl(VRRadiobutton,'yuwin10','yu-win10.map �i�������E���S�V�b�N��p���܂� (Windows 10)�D�j',20,220,500,20);
			@yuwin10.setFont(@font);
			addControl(VRRadiobutton,'noembed','noembed.map �i���ߍ��݂܂���DTeXworks �ł͂l�r �����݂̂ŕ\���D�j',20,240,500,20);
			@noembed.setFont(@font);
			addControl(VRCheckbox,'jischk','2004JIS ���`���g���D�i�f�t�H���g�̎w���I�����͖�������܂��D�j',20,260,500,20);
			@jischk.setFont(@font);
			addControl(VRButton,'OK','OK',305,290,30,20);
			@OK.setFont(@font);
			addControl(VRButton,'Cancel','��ݾ�',345,290,60,20);
			@Cancel.setFont(@font);
			
			set_data(options['embed'],options['shortcut'],options['jis']);
		end
		
		def set_data(emb,shortcut,jis)
			@embed = emb;
			all_check_clear;
			case emb
			when 'msmingoth'
				@msmingoth.check(true);
			when 'hiragino'
				@hiragino.check(true);
			when 'hiraginopron'
				@hiraginopron.check(true);
			when 'ipaex'
				@ipaex.check(true);
			when 'kozuka'
				@kozuka.check(true);
			when 'kozukapr6n'
				@kozukapr6n.check(true);
			when 'yu'
				@yu.check(true);
			when 'yuwin10'
				@yuwin10.check(true);
			when 'noembed'
				@noembed.check(true);
			else
				@default.check(true);
			end
			@shortcut = shortcut;
			@shortcutchk.check(shortcut);
			@jis = jis;
			@jischk.check(jis);
		end
		
		def OK_clicked
			@embed = get_embed_status;
			if @embed == nil then @embed = 'default'; end
			@jis04 = get_jis04_status;
			if @jis04 == nil then @jis04 = ''; end
			@shortcut = @shortcutchk.checked?;
			@jis = @jischk.checked?;
			close([@embed,@shortcut,@jis]);
		end
		
		def Cancel_clicked
			close(nil);
		end
	
	private
		def get_embed_status
			if @default.checked? then return "default"; end
			if @msmingoth.checked? then return "msmingoth"; end
			if @hiragino.checked? then return "hiragino"; end
			if @hiraginopron.checked? then return "hiraginopron"; end
			if @ipaex.checked? then return "ipaex"; end
			if @kozuka.checked? then return "kozuka"; end
			if @kozukapr6n.checked? then return "kozukapr6n"; end
			if @yu.checked? then return "yu"; end
			if @yuwin10.checked? then return "yu-win10"; end
			if @noembed.checked? then return "noembed"; end
			return nil;
		end
	
		def get_jis04_status
			if @jischk.checked? then return "04"; end
			return nil;
		end
	
		def all_check_clear
			@default.check(false);
			@msmingoth.check(false);
			@hiragino.check(false);
			@hiraginopron.check(false);
			@ipaex.check(false);
			@kozuka.check(false);
			@kozukapr6n.check(false);
			@yu.check(false);
			@yuwin10.check(false);
			@noembed.check(false);
		end
		
	end



	class TeXworks
		def initialize
			@ini = "";
			@log = "";
			@inisec = 'plugin_TeXworks';
		end
		
		def info
			return [{"softname" => "TeXworks", "info" => "TeXworks �̐ݒ�"}];
		end
		
		
		def plugin_init(ini,log)
			@ini = ini;
			@log = log;
			@embed = AbTeXinst::get_ini_str(ini,@inisec,'embed');
			if @embed == nil || @embed == "" then
				@embed = 'default';
			end
			sc = AbTeXinst::get_ini_str(ini,@inisec,'shortcut');
			@shortcut = false;
			if sc == nil || sc == "" || sc == 'true' then
				@shortcut = true;
			end
			j = AbTeXinst::get_ini_str(ini,@inisec,'jis');
			if j == 'true' then @jis = true; else @jis = false; end;
		end
		
		
		def reboot?()
			return false;
		end
		
		
		def set?(soft)
			return true;
		end
		
		
		def set(hwnd,soft)
			par = SWin::LWFactory.new(SWin::Application.hInstance).newwindow(nil,SWin::Window);
			AbTeXinst::sethwndtovrobj(par,hwnd);
			rv = VRLocalScreen.modalform(par,nil,SetForm,nil,{'embed'=>@embed,'shortcut'=>@shortcut,'jis' => @jis});
			if rv then @embed,@shortcut,@jis = rv; end
			return;
		end
		
		
		def get_info(hwnd)
			return true;
		end
		
		
		def download_data(soft)
			return {
				"success" => true,
				"download_files" => []};
		end
		
		
		def default?(soft)
			return (
				(@shortcut && !File.exist?(AbTeXinst::get_specialfolder(AbTeXinst::CSIDL_DESKTOP) + '\TeXworks.lnk')) || 
				(@embed != 'default' && !File.exist?(AbTeXinst::Setting::install_dir + "bin\\pdfplatex_#{@embed}.bat"))
			)
		end
		
		
		def install(hwnd,soft,dlresult)
			texworksexe = AbTeXinst::Setting::install_dir + 'share\texworks\TeXworks.exe';
			
			if !File.exist?(texworksexe) then
				Log("TeXworks���C���X�g�[������Ă��Ȃ��悤�ł��D");
				AbTeXinst::add_message(hwnd,"TeXworks�̔����Ɏ��s\r\n");
				return false;
			end
			
			AbTeXinst::add_message(hwnd,'TeXworks�̐ݒ�c�c\r\n');
			result = true;
			if @shortcut then
				Log("TeXworks�̃V���[�g�J�b�g�쐬");
				if AbTeXinst::create_shortcut(texworksexe,'',AbTeXinst::Setting::install_dir + 'share\texworks',AbTeXinst::get_specialfolder(AbTeXinst::CSIDL_DESKTOP) + '\TeXworks.lnk') == true then
					msg = "����";
				else
					msg = "���s";
					result = false;
				end
				Log("TeXworks�̃V���[�g�J�b�g�쐬��" + msg);
			end
			
			AbTeXinst::add_message(hwnd,'TeXworks�p�̃o�b�`�t�@�C�����쐬');
			Dir.glob(File.expand_path(AbTeXinst::Setting::install_dir + 'share/texmf-dist/fonts/map/dvipdfmx/base/*.map')).each{|mapfile|
				if /cid|base14|omegaj|ckx/ =~ mapfile then next;end
				mapfile = Pathname(mapfile).basename.to_s.gsub(/\.map$/,'');
				begin
					fp = File.open(AbTeXinst::Setting::install_dir + 'bin\pdfplatex_' + mapfile + '.bat','w');
					fp.write("@echo off\nplatex -synctex=1 -jobname=\"%~n1\" -kanji=utf8 -guess-input-enc %1 && ^\ndvipdfmx -f #{mapfile}.map \"%~n1\"\n");
#					fp.write("@echo off\nplatex -synctex=1 -jobname=\"%~n1\" %1 && ^\ndvipdfmx -f #{mapfile}.map \"%~n1\"\n");
					Log("pdfplatex_#{mapfile}.bat�̐����ɐ���");
				rescue => excep
					Log("pdfplatex_#{mapfile}.bat�̐����Ɏ��s " + excep.to_s);
					result = false;
				ensure
					if fp then fp.close(); end
				end
			}
			pdfplatexbat = '';
			case @embed
			when 'default'
				pdfplatexbat = 'pdfplatex.bat';
			else
				if @jis == true then
					pdfplatexbat = 'pdfplatex_' + @embed + '04.bat';
				else
					pdfplatexbat = 'pdfplatex_' + @embed + '.bat';
				end
			end
			
			if !File.exist?(AbTeXinst::Setting::install_dir + "bin\\#{pdfplatexbat}") then
				Log("TeXworks: �a���t�H���g " + @embed + (@jis == true ? "�i2004JIS ���`�j" : "") + " �̖��ߍ��݂悤�ݒ�t�@�C���̓V�X�e���ɗp�ӂ���Ă��Ȃ��悤�ł��D�f�t�H���g�̃t�H���g�ݒ���g���܂��D");
				pdfplatexbat = "pdfplatex.bat";
				AbTeXinst::add_message(hwnd,"�w�肳�ꂽ�t�H���g�͎g���܂���D\r\n");
			end
			
			AbTeXinst::add_message(hwnd,'TeXworks�̐ݒ��ύX');
			ini = AbTeXinst::Setting::install_dir + 'share\texworks\twdata\configuration\tools.ini';
			
			set_done = false;
			1.upto(100){|n|
				sec = sprintf('%03d',n);
				if AbTeXinst::get_ini_str(ini,sec,'name') == 'pdfpLaTeX' then
					if AbTeXinst::write_ini_str(ini,sec,'program',pdfplatexbat) then
						set_done = true;
						Log("pdfpLaTeX�̐ݒ��#{pdfplatexbat}�ɕύX");
						break;
					end
				end
			}
			
			if !set_done then
				Log('TeXworks/pdfpLaTeX�̐ݒ�ύX�Ɏ��s');
				result = false;
			end
			
			
#			if set_done then
#				n = 1;
#				name = '';
#				noembed_found = false;
#				begin
#					name = AbTeXinst::get_ini_str(ini,sprintf('%03d',n),'name');
#					if name == 'pdfpLaTeX_noEmbed' then
#						noembed_found = true;
#						break;
#					end
#					n += 1;
#				end while name != ''
#				if !noembed_found then
#					sec = sprintf('%03d',n);
#					AbTeXinst::write_ini_str(ini,sec,'name','pdfpLaTeX_noEmbed');
#					AbTeXinst::write_ini_str(ini,sec,'program','pdfplatex.bat');
#					AbTeXinst::write_ini_str(ini,sec,'arguments','$fullname');
#					AbTeXinst::write_ini_str(ini,sec,'showPdf','true');
#				end
#			else
#				Log('TeXworks/pdfpLaTeX�̐ݒ�ύX�Ɏ��s');
#				result = false;
#			end
			
			AbTeXinst::add_message(hwnd,(result ? '����' : '���s') + "\r\n");
			return result;
		end
		
		def plugin_uninit
			if AbTeXinst::Setting::write_ini? then
				AbTeXinst::write_ini_str(@ini,@inisec,'embed',@embed);
				AbTeXinst::write_ini_str(@ini,@inisec,'shortcut',@shortcut ? 'true' : 'false');
				AbTeXinst::write_ini_str(@ini,@inisec,'jis',@jis ? 'true' : 'false');
			end
		end
		
	private
		def Log(l)
			begin
				fp = File.open(@log,"a+");
			rescue
				return;
			end
			fp.write(l + "\n");
			fp.close();
		end
		
	end
	
end

AbTeXinst::register_plugin("TeXworks",TeXworksMod::TeXworks);

